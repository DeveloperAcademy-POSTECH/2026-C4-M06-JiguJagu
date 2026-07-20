//
//  CameraCaptureView.swift
//  JiguJagu
//
//  Created by SIA on 7/18/26.
//

import SwiftUI

// MARK: - Configuration

/// 촬영 화면 하나의 문구·버튼 구성을 정의합니다.
/// 옷 촬영 / 택 촬영처럼 화면별로 다른 값을 주입해 재사용합니다.
struct CameraCaptureConfig {
    
    /// 좌상단 버튼 종류
    enum LeadingAction {
        case close  // X (플로우 종료)
        case back   // ← (이전 단계로)
    }
    
    var leadingAction: LeadingAction
    /// 기본 안내 문구 (예: "세탁할 옷을 촬영해 주세요.")
    var instruction: String
    /// 인식이 잘 안 될 때 안내 문구 (예: "옷이 잘 인식되지 않나요?")
    var helperPrompt: String?
    /// 보조 액션 텍스트 (예: "옷 검색하기")
    var helperActionTitle: String?
    
    /// 옷 촬영 화면
    static let clothing = CameraCaptureConfig(
        leadingAction: .close,
        instruction: "세탁할 옷을 촬영해 주세요.",
        helperPrompt: "옷이 잘 인식되지 않나요?",
        helperActionTitle: "옷 검색하기"
    )
    
    /// 세탁 라벨 촬영 화면
    static let tag = CameraCaptureConfig(
        leadingAction: .back,
        instruction: "옷의 세탁 라벨을 촬영해 주세요.",
        helperPrompt: "세탁 라벨이 보이지 않나요?",
        helperActionTitle: "촬영 건너뛰기"
    )
}

// MARK: - Camera Capture View

/// 옷/세탁 라벨 촬영을 위한 카메라 화면.
///
/// 사용 예시는 파일 하단의 `LaundryCaptureFlow` 참고.
struct CameraCaptureView: View {
    
    let config: CameraCaptureConfig
    
    /// 이 시간(초)이 지나면 보조 안내(helperPrompt)를 노출합니다.
    /// nil이면 항상 기본 안내만 표시합니다.
    var revealHelperAfter: TimeInterval? = 5
    
    var onLeadingAction: () -> Void = {}
    var onHelperAction: () -> Void = {}
    var onCapture: (UIImage) -> Void = { _ in }
    
    @StateObject private var camera = CameraModel()
    @State private var showHelper = false
    @State private var shutterOpacity: Double = 0
    @State private var isCapturing = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if camera.isConfigured {
                CameraPreview(session: camera.session)
                    .ignoresSafeArea()
            }
            
            // 촬영 순간의 흰 플래시 효과
            Color.white
                .ignoresSafeArea()
                .opacity(shutterOpacity)
            
            if camera.permissionDenied {
                permissionDeniedView
            } else {
                overlay
            }
        }
        .foregroundColor(.white)
        .onAppear { camera.checkPermissionAndConfigure() }
        .onDisappear { camera.stop() }
        .task {
            guard let delay = revealHelperAfter, config.helperPrompt != nil else { return }
            do {
                try await Task.sleep(for: .seconds(delay))
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            withAnimation { showHelper = true }
        }
    }
    
    // MARK: Overlay Layout
    
    private var overlay: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                Spacer()
                
                CornerBracketsView()
                    .frame(height: geo.size.height * 0.45)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                bottomArea
                    .padding(.bottom, 24)
            }
        }
    }
    
    // MARK: Top Bar
    
    private var topBar: some View {
        ZStack {
            // 가운데: 플래시 토글
            Button(action: camera.toggleFlash) {
                Image(systemName: camera.flashIconName)
                    .font(.system(size: 20, weight: .medium))
            }
            
            // 왼쪽: 닫기 / 뒤로
            HStack {
                Button(action: onLeadingAction) {
                    Image(systemName: config.leadingAction == .close ? "xmark" : "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                }
                Spacer()
            }
        }
        .frame(height: 44)
    }
    
    // MARK: Bottom Area
    
    private var bottomArea: some View {
        VStack(spacing: 28) {
            captionRow
            captureButton
        }
    }
    
    @ViewBuilder
    private var captionRow: some View {
        if showHelper,
           let prompt = config.helperPrompt,
           let action = config.helperActionTitle {
            HStack(spacing: 8) {
                Text(prompt)
                Button(action: onHelperAction) {
                    Text(action).underline()
                }
            }
            .font(.system(size: 15))
            .transition(.opacity)
        } else {
            Text(config.instruction)
                .font(.system(size: 15))
        }
    }
    
    private var captureButton: some View {
        Button {
            capture()
        } label: {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 4)
                    .frame(width: 74, height: 74)
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
            }
        }
        .disabled(!camera.isConfigured || isCapturing)
    }
    
    // MARK: Permission Denied
    
    private var permissionDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 40))
            Text("카메라 권한이 필요합니다.")
                .font(.system(size: 16, weight: .semibold))
            Text("설정 > 개인정보 보호에서 카메라 접근을 허용해 주세요.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Button("설정 열기") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .padding(.top, 8)
        }
        .padding(32)
    }
    
    // MARK: Actions
    
    private func capture() {
        guard !isCapturing else { return }
        isCapturing = true
        
        // 셔터 플래시
        withAnimation(.easeOut(duration: 0.08)) { shutterOpacity = 0.9 }
        withAnimation(.easeIn(duration: 0.25).delay(0.08)) { shutterOpacity = 0 }
        
        Task {
            let image = await camera.capturePhoto()
            isCapturing = false
            if let image { onCapture(image) }
        }
    }
}

// MARK: - 사용 예시: 옷 → 택 → 상품 검색 플로우

/// 옷을 먼저 촬영하고, 택을 촬영하거나 "택 촬영 건너뛰기"를 누르면
/// 앞서 찍은 옷 사진으로 상품을 검색(식별)하는 플로우.
struct LaundryCaptureFlow: View {
    
    enum Step { case clothing, tag, result }
    
    @Environment(\.dismiss) private var dismiss
    @State private var step: Step = .clothing
    @State private var clothingImage: UIImage?
    @State private var tagImage: UIImage?
    
    var body: some View {
        switch step {
        case .clothing:
            CameraCaptureView(
                config: .clothing,
                onLeadingAction: { dismiss() },              // X → 플로우 종료
                onHelperAction: { /* 옷 검색 화면으로 이동 */ },
                onCapture: { image in
                    clothingImage = image
                    step = .tag                               // 다음 단계로
                }
            )
            
        case .tag:
            CameraCaptureView(
                config: .tag,
                onLeadingAction: { step = .clothing },        // ← 옷 촬영으로 복귀
                onHelperAction: { step = .result },           // 세탁 라벨 촬영 건너뛰기 → 상품 검색
                onCapture: { image in
                    tagImage = image
                    step = .result                            // 세탁 라벨 촬영 후에도 상품 검색
                }
            )
            
        case .result:
            ProductResultView(
                image: clothingImage,                         // 앞서 찍은 옷 사진으로 분석
                onDone: { dismiss() }
            )
        }
    }
}

#Preview("옷 촬영") {
    CameraCaptureView(config: .clothing)
}

#Preview("세탁 라벨 촬영") {
    CameraCaptureView(config: .tag, revealHelperAfter: nil)
}
