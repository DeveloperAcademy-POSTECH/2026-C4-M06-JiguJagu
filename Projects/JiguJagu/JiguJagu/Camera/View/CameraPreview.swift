//
//  CameraPreview.swift
//  JiguJagu
//
//  Created by SIA on 7/18/26.
//

import SwiftUI
import AVFoundation

/// `AVCaptureSession`의 실시간 영상을 SwiftUI에 표시하는 프리뷰 뷰.
struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}

    /// 레이어 자체가 `AVCaptureVideoPreviewLayer`인 UIView.
    final class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
}
