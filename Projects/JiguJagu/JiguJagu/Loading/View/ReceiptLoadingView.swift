//
//  ReceiptLoadingView.swift
//  JiguJagu
//
//  Created by mason on 7/22/26.
//

import SwiftUI

struct ReceiptLoadingView: View {
    @State private var controller: LoadingController

    init(controller: LoadingController = LoadingController(configuration: .receiptIssuing)) {
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
                        x: geometry.size.width / 2,
                        y: scaledContentCenterY(for: geometry.size)
                    )
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
        .accessibilityIdentifier(LoadingAccessibilityIdentifier.receiptIssuingScreen)
        .onAppear {
            controller.startProgressLoop()
        }
        .onDisappear {
            controller.stopProgressLoop()
        }
    }
}

private extension ReceiptLoadingView {
    var loadingContent: some View {
        VStack(spacing: 11) {
            VStack(spacing: 24) {
                ReceiptLoadingIllustrationView()

                Text(controller.progressState.message)
                    .font(.pretendard.head5)
                    .foregroundStyle(Color.grayScale900)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel(controller.progressState.message)
                    .accessibilityIdentifier(LoadingAccessibilityIdentifier.receiptIssuingMessage)
            }

            LoadingProgressBar(progress: controller.progressState.progress)
                .frame(width: ReceiptLoadingLayout.progressWidth, height: ReceiptLoadingLayout.progressHeight)
                .accessibilityLabel(controller.progressState.accessibilityProgressLabel)
                .accessibilityValue(controller.progressState.accessibilityProgressValue)
                .accessibilityIdentifier(LoadingAccessibilityIdentifier.receiptIssuingProgressBar)
        }
        .frame(width: ReceiptLoadingLayout.contentWidth, height: ReceiptLoadingLayout.contentHeight)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(LoadingAccessibilityIdentifier.receiptIssuingContent)
    }

    func layoutScale(for size: CGSize) -> CGFloat {
        min(size.width / ReceiptLoadingLayout.designWidth, size.height / ReceiptLoadingLayout.designHeight)
    }

    func scaledContentCenterY(for size: CGSize) -> CGFloat {
        let scale = layoutScale(for: size)
        let topInset = (size.height - ReceiptLoadingLayout.designHeight * scale) / 2

        return topInset + ReceiptLoadingLayout.contentCenterY * scale
    }
}

private enum ReceiptLoadingLayout {
    static let designWidth: CGFloat = 393
    static let designHeight: CGFloat = 852
    static let contentWidth: CGFloat = 241
    static let contentHeight: CGFloat = 264
    static let contentTop: CGFloat = 279
    static let progressWidth: CGFloat = 241
    static let progressHeight: CGFloat = 10

    static var contentCenterY: CGFloat {
        contentTop + contentHeight / 2
    }
}

#Preview {
    ReceiptLoadingView()
}
