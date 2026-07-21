//
//  CameraModel.swift
//  JiguJagu
//
//  Created by SIA on 7/18/26.
//
import AVFoundation
import Combine
import UIKit

/// 카메라 세션·권한·플래시·촬영을 담당하는 모델.
///
/// - 클래스는 `@MainActor`(UI 상태 갱신용)이고,
///   무거운 세션 작업은 `sessionQueue`(백그라운드)에서 실행합니다.
/// - 세션/출력 객체는 `sessionQueue`에서만 접근하므로 `nonisolated(unsafe)`로 표시했습니다.
/// - 촬영 상태(`captureContinuation`, `pendingCaptureID`)도 오직 `sessionQueue`에서만
///   읽고 씁니다. 이 규율 덕분에 촬영 완료 콜백과 취소 정리가 서로 겹쳐도 안전합니다.
@MainActor
final class CameraModel: NSObject, ObservableObject {
    
    // MARK: - Published State (main actor)
    
    /// 세션 구성이 끝나 프리뷰를 그릴 수 있는 상태인지 여부
    @Published var isConfigured = false
    /// 카메라 권한이 거부된 상태
    @Published var permissionDenied = false
    /// 현재 플래시 모드 (off → on → auto 순환)
    @Published var flashMode: AVCaptureDevice.FlashMode = .off
    
    // MARK: - Capture Objects (accessed on sessionQueue)
    
    nonisolated(unsafe) let session = AVCaptureSession()
    private nonisolated(unsafe) let photoOutput = AVCapturePhotoOutput()
    private nonisolated let sessionQueue = DispatchQueue(label: "com.laundry.camera.session")
    
    /// async 촬영을 위한 continuation (촬영 완료·취소 시 재개). sessionQueue에서만 접근.
    private nonisolated(unsafe) var captureContinuation: CheckedContinuation<UIImage?, Never>?
    /// 현재 진행 중인 촬영 요청의 식별자(settings.uniqueID). sessionQueue에서만 접근.
    ///
    /// 취소로 continuation을 먼저 정리한 뒤, 뒤늦게 도착한 delegate 콜백이
    /// 이후의 새 요청을 잘못 resume 하는 것을 막기 위한 토큰입니다.
    private nonisolated(unsafe) var pendingCaptureID: Int64?
    
    // MARK: - Permission & Configuration
    
    /// 권한을 확인하고, 허용된 경우 세션을 구성합니다.
    func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                Task { @MainActor [weak self] in
                    guard let self else { return }

                    if granted {
                        self.configureSession()
                    } else {
                        self.permissionDenied = true
                    }
                }
            }

        default:
            permissionDenied = true
        }
    }
    
    private func configureSession() {
        // 중복 구성 방지: 이미 구성이 끝났다면 재실행하지 않음
        guard !isConfigured else { return }

        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            
            // 후면 카메라 입력
            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                     for: .video,
                                                     position: .back),
                let input = try? AVCaptureDeviceInput(device: device),
                self.session.canAddInput(input)
            else {
                self.session.commitConfiguration()
                return
            }
            self.session.addInput(input)
            
            // 사진 출력
            if self.session.canAddOutput(self.photoOutput) {
                self.session.addOutput(self.photoOutput)
                self.photoOutput.maxPhotoQualityPrioritization = .quality
            }
            
            self.session.commitConfiguration()
            self.session.startRunning()
            
            Task { @MainActor [weak self] in
                self?.isConfigured = true
            }
        }
    }
    
    // MARK: - Session Lifecycle
    
    func start() {
        sessionQueue.async { [weak self] in
            guard let self, !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }
    
    func stop() {
        sessionQueue.async { [weak self] in
            guard let self, self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }
    
    // MARK: - Flash
    
    /// off → on → auto 순으로 플래시 모드를 순환합니다.
    func toggleFlash() {
        switch flashMode {
        case .off:  flashMode = .on
        case .on:   flashMode = .auto
        case .auto: flashMode = .off
        @unknown default: flashMode = .off
        }
    }
    
    /// 현재 플래시 모드에 해당하는 SF Symbol 이름
    var flashIconName: String {
        switch flashMode {
        case .on:   return "bolt.fill"
        case .auto: return "bolt.badge.a.fill"
        default:    return "bolt.slash.fill"
        }
    }
    
    // MARK: - Capture
    
    /// 사진을 촬영하고 결과 이미지를 반환합니다.
    /// 실패하거나 이미 촬영 중인 경우, 또는 취소된 경우 nil.
    ///
    /// 취소(화면 종료 등)가 발생하면 `withTaskCancellationHandler`가
    /// 대기 중인 continuation을 sessionQueue 위에서 정리해 hang을 방지합니다.
    func capturePhoto() async -> UIImage? {
        let mode = flashMode

        return await withTaskCancellationHandler {
            await withCheckedContinuation { continuation in
                sessionQueue.async { [weak self] in
                    guard let self else {
                        continuation.resume(returning: nil)
                        return
                    }

                    // 기존 촬영이 진행 중이면 새로운 요청을 거절
                    guard self.captureContinuation == nil else {
                        continuation.resume(returning: nil)
                        return
                    }

                    let settings = AVCapturePhotoSettings()
                    settings.photoQualityPrioritization = .quality

                    if self.photoOutput.supportedFlashModes.contains(mode) {
                        settings.flashMode = mode
                    }

                    // 이 요청을 식별할 토큰과 continuation을 저장
                    self.captureContinuation = continuation
                    self.pendingCaptureID = settings.uniqueID

                    self.photoOutput.capturePhoto(
                        with: settings,
                        delegate: self
                    )
                }
            }
        } onCancel: {
            // onCancel은 임의 스레드에서 동기 실행되므로
            // 반드시 sessionQueue로 hop 하여 촬영 상태에 접근한다.
            sessionQueue.async { [weak self] in
                guard let self, let continuation = self.captureContinuation else { return }
                self.captureContinuation = nil
                self.pendingCaptureID = nil
                continuation.resume(returning: nil)
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraModel: AVCapturePhotoCaptureDelegate {

    /// 촬영된 사진 처리가 끝났을 때 호출됩니다.
    nonisolated func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        // UIImage 대신 Sendable인 Data를 큐로 전달.
        // 어느 요청의 콜백인지 식별할 uniqueID도 hop 전에 미리 꺼내둔다.
        let imageData: Data? = (error == nil) ? photo.fileDataRepresentation() : nil
        let uniqueID = photo.resolvedSettings.uniqueID

        sessionQueue.async { [weak self] in
            guard let self else { return }

            // 대기 중인 요청이 있고, 그 요청이 바로 이 콜백에 해당할 때만 처리.
            // (취소로 이미 정리되었거나, 다른 요청으로 교체된 경우엔 무시)
            guard
                let continuation = self.captureContinuation,
                self.pendingCaptureID == uniqueID
            else {
                return
            }

            // 먼저 상태를 비워 중복 resume 방지
            self.captureContinuation = nil
            self.pendingCaptureID = nil

            let image = imageData.flatMap { UIImage(data: $0) }
            continuation.resume(returning: image)
        }
    }
}
