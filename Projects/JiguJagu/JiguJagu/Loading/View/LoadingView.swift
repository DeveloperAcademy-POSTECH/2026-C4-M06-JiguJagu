//
//  LoadingView.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var controller: LoadingController

    init(controller: LoadingController = LoadingController()) {
        _controller = State(initialValue: controller)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image("MainBG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .opacity(0.3)
                    .ignoresSafeArea()

                loadingContent
                    .scaleEffect(layoutScale(for: geometry.size), anchor: .top)
                    .position(
                        x: geometry.size.width / 2 - scaledHorizontalOffset(for: geometry.size),
                        y: scaledContentCenterY(for: geometry.size)
                    )
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
        .onAppear {
            controller.startProgressLoop()
        }
        .onDisappear {
            controller.stopProgressLoop()
        }
    }
}

private extension LoadingView {
    var loadingContent: some View {
        VStack(spacing: 11) {
            VStack(spacing: 10) {
                LoadingAnimationView()

                Text(controller.progressState.message)
                    .font(.pretendard.head5)
                    .foregroundStyle(Color.grayScale900)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(controller.progressState.message)
            }

            LoadingProgressBar(progress: controller.progressState.progress)
                .frame(width: LoadingLayout.progressWidth, height: LoadingLayout.progressHeight)
                .accessibilityLabel("의류 탐색 진행률")
                .accessibilityValue(controller.progressState.accessibilityProgressValue)
        }
        .frame(width: LoadingLayout.contentWidth, height: LoadingLayout.contentHeight)
        .accessibilityElement(children: .contain)
    }

    func layoutScale(for size: CGSize) -> CGFloat {
        min(size.width / LoadingLayout.designWidth, size.height / LoadingLayout.designHeight)
    }

    func scaledHorizontalOffset(for size: CGSize) -> CGFloat {
        LoadingLayout.contentHorizontalOffset * layoutScale(for: size)
    }

    func scaledContentCenterY(for size: CGSize) -> CGFloat {
        let scale = layoutScale(for: size)
        let topInset = (size.height - LoadingLayout.designHeight * scale) / 2

        return topInset + LoadingLayout.contentCenterY * scale
    }
}

private enum LoadingLayout {
    static let designWidth: CGFloat = 393
    static let designHeight: CGFloat = 852
    static let contentWidth: CGFloat = 247
    static let contentHeight: CGFloat = 255
    static let contentTop: CGFloat = 268
    static let contentHorizontalOffset: CGFloat = 3
    static let progressWidth: CGFloat = 247
    static let progressHeight: CGFloat = 10

    static var contentCenterY: CGFloat {
        contentTop + contentHeight / 2
    }
}

#Preview {
    LoadingView()
}
