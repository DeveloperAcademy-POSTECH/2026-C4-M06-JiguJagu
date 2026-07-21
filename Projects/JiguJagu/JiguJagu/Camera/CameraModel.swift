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

    /// async 촬영을 위한 continuation (촬영 완료 시 재개)
    private nonisolated(unsafe) var captureContinuation: CheckedContinuation<UIImage?, Never>?

    // MARK: - Permission & Configuration

    /// 권한을 확인하고, 허용된 경우 세션을 구성합니다.
    func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
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

    /// 사진을 촬영하고 결과 이미지를 반환합니다. 실패 시 nil.
    func capturePhoto() async -> UIImage? {
        let mode = flashMode  // Sendable 값만 백그라운드로 전달
        return await withCheckedContinuation { continuation in
            sessionQueue.async { [weak self] in
                guard let self else {
                    continuation.resume(returning: nil)
                    return
                }
                captureContinuation = continuation

                // settings는 백그라운드 큐 안에서 생성 (non-Sendable 캡처 방지)
                let settings = AVCapturePhotoSettings()
                if self.photoOutput.supportedFlashModes.contains(mode) {
                    settings.flashMode = mode
                }
                self.photoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraModel: AVCapturePhotoCaptureDelegate {
    /// delegate 콜백은 백그라운드 큐에서 호출되므로 nonisolated.
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput,
                                 didFinishProcessingPhoto photo: AVCapturePhoto,
                                 error: Error?) {
        var image: UIImage?
        if error == nil, let data = photo.fileDataRepresentation() {
            image = UIImage(data: data)
        }
        // 촬영은 한 번에 하나씩만 진행되므로 여기서 바로 재개.
        captureContinuation?.resume(returning: image)
        captureContinuation = nil
    }
}
