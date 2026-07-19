//
//  CameraModel.swift
//  JiguJagu
//
//  Created by SIA on 7/18/26.
//

import Combine
@preconcurrency import AVFoundation
import SwiftUI

/// 카메라 세션·권한·플래시·촬영을 담당하는 모델.
///
/// - 세션 설정/시작/정지 같은 무거운 작업은 `sessionQueue`(백그라운드)에서 실행합니다.
/// - `@Published` 값은 항상 메인 스레드에서 갱신합니다.
final class CameraModel: NSObject, ObservableObject {

    // MARK: - Published State

    /// 세션 구성이 끝나 프리뷰를 그릴 수 있는 상태인지 여부
    @Published var isConfigured = false
    /// 카메라 권한이 거부된 상태
    @Published var permissionDenied = false
    /// 현재 플래시 모드 (off → on → auto 순환)
    @Published var flashMode: AVCaptureDevice.FlashMode = .off

    // MARK: - Capture Objects

    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.laundry.camera.session")

    /// async 촬영을 위한 continuation (촬영 완료 시 재개)
    private var captureContinuation: CheckedContinuation<UIImage?, Never>?

    // MARK: - Permission & Configuration

    /// 권한을 확인하고, 허용된 경우 세션을 구성합니다.
    func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.configureSession()
                    } else {
                        self?.permissionDenied = true
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

            DispatchQueue.main.async {
                self.isConfigured = true
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
        await withCheckedContinuation { continuation in
            self.captureContinuation = continuation

            let settings = AVCapturePhotoSettings()
            if self.photoOutput.supportedFlashModes.contains(self.flashMode) {
                settings.flashMode = self.flashMode
            }

            self.sessionQueue.async { [weak self] in
                guard let self else { return }
                self.photoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        defer { captureContinuation = nil }

        guard
            error == nil,
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else {
            captureContinuation?.resume(returning: nil)
            return
        }
        captureContinuation?.resume(returning: image)
    }
}
