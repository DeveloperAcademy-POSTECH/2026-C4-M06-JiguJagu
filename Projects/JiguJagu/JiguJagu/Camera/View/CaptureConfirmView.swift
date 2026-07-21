//
//  CaptureConfirmView.swift
//  JiguJagu
//
//  Created by SIA on 7/22/26.
//

import SwiftUI

/// 촬영 직후 결과를 확인하는 화면.

struct CaptureConfirmView: View {

    /// 방금 촬영한 원본 이미지
    let image: UIImage

    /// 배경을 어둡게 하는 정도 (0 = 그대로, 1 = 완전 검정)
    var backgroundDim: Double = 0.85

    /// 좌상단 X (플로우 종료)
    var onClose: () -> Void = {}
    /// 재촬영 (다시 촬영)
    var onRetake: () -> Void = {}
    /// 확인 (다음 단계로)
    var onConfirm: () -> Void = {}

    /// orientation 정규화된 원본 (배경으로 어둡게 깔림)
    @State private var normalized: UIImage?
    /// 누끼 딴 피사체 (배경 투명, 원래 밝기로 위에 올림)
    @State private var cutout: UIImage?
    /// 누끼 처리 진행 중 여부
    @State private var isProcessing = true

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            photoLayer

            // 누끼 처리 중에는 사진 전체가 어둡게 보이므로 안내 인디케이터 표시
            if isProcessing {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("사진을 확인하고 있어요")
                        .font(.pretendard.body5)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }

            overlay
        }
        .foregroundColor(.white)
        .task { await process() }
    }

    // MARK: - Photo Layer

    /// 원본(어둡게) 위에 누끼 딴 피사체(밝게)를 겹쳐 그립니다.
    private var photoLayer: some View {
        GeometryReader { geo in
            ZStack {
                // 1) 원본 — 배경 포함해서 어둡게 깔림
                if let normalized {
                    Image(uiImage: normalized)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }

                // 2) 배경 어둡게
                Color.black
                    .opacity(normalized == nil ? 0 : backgroundDim)
                    .frame(width: geo.size.width, height: geo.size.height)

                // 3) 누끼 딴 피사체 — 같은 프레임/스케일이라 원본과 정확히 정렬
                if let cutout {
                    Image(uiImage: cutout)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .transition(.opacity)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }

    // MARK: - Overlay (top bar · brackets · buttons)

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

                bottomButtons
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .medium))
            }
            Spacer()
        }
        .frame(height: 44)
    }

    // MARK: - Bottom Buttons

    private var bottomButtons: some View {
        HStack(spacing: 12) {
            // 재촬영 (보조 · 밝은 배경)
            Button(action: onRetake) {
                Text("재촬영")
                    .font(.pretendard.body6)
                    .foregroundStyle(Color.grayScale900)
                    .frame(width: 108)
                    .frame(height: 52)
                    .background(Color.white)
                    .clipShape(Capsule())
            }

            // 확인 (주요 · Primary)
            Button(action: onConfirm) {
                Text("확인")
                    .font(.pretendard.body6)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.primary500)
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Processing

    /// 원본 정규화 → 누끼 추출을 순서대로 수행합니다.
    private func process() async {
        // 먼저 정규화된 원본을 띄워 화면이 비어 보이지 않게 함
        let upright = image.normalizedUp()
        normalized = upright

        // 누끼 추출 (실패 시 cutout은 nil로 남고, 배경 어둡게만 적용됨)
        let extracted = await ForegroundCutout.extract(from: upright)

        withAnimation(.easeIn(duration: 0.25)) {
            cutout = extracted
            isProcessing = false
        }
    }
}

#Preview {
    // 프리뷰에서는 시스템 이미지를 원본처럼 사용
    CaptureConfirmView(
        image: UIImage(systemName: "tshirt.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage()
    )
}
