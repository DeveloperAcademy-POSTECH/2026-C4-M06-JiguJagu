//
//  ReceiptLoadingIllustrationView.swift
//  JiguJagu
//
//  Created by mason on 7/22/26.
//

import SwiftUI

struct ReceiptLoadingIllustrationView: View {
    @State private var issueProgress = 0.0

    var body: some View {
        ZStack(alignment: .topLeading) {
            receiptContent
                .offset(y: receiptOffsetY)
                .mask(alignment: .topLeading) {
                    Rectangle()
                        .frame(width: Metric.receiptWidth, height: Metric.receiptHeight)
                        .offset(x: Metric.receiptX, y: Metric.receiptClipY)
                }
                .zIndex(2)

            printer
                .zIndex(1)

            slotBridgeLine
                .zIndex(3)
        }
        .frame(width: 180, height: 180)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("영수증이 출력되는 로딩 일러스트")
        .task {
            await startIssuingAnimationLoop()
        }
    }
}

private extension ReceiptLoadingIllustrationView {
    var printer: some View {
        Image("ReceiptLoadingPrinter")
            .resizable()
            .frame(width: Metric.printerWidth, height: Metric.printerHeight)
            .offset(x: Metric.printerX, y: Metric.printerY)
    }

    var slotBridgeLine: some View {
        Rectangle()
            .fill(Color.grayScale900)
            .frame(width: Metric.slotBridgeLineWidth, height: Metric.slotBridgeLineHeight)
            .offset(x: Metric.slotBridgeLineX, y: Metric.slotBridgeLineY)
    }

    var receiptContent: some View {
        ZStack(alignment: .topLeading) {
            Image("ReceiptLoadingPaper")
                .resizable()
                .frame(width: Metric.receiptWidth, height: Metric.receiptHeight)
                .offset(x: Metric.receiptX, y: Metric.receiptY)

            Image("LoadingEarthIcon")
                .resizable()
                .scaledToFit()
                .frame(width: Metric.earthWidth, height: Metric.earthHeight)
                .offset(x: Metric.earthX, y: Metric.earthY)

            Image("ReceiptLoadingTearLine")
                .resizable()
                .frame(width: Metric.tearLineWidth, height: Metric.tearLineHeight)
                .offset(x: Metric.tearLineX, y: Metric.tearLineY)

            ReceiptLoadingBarcodeView()
                .frame(width: Metric.barcodeWidth, height: Metric.barcodeHeight)
                .offset(x: Metric.barcodeX, y: Metric.barcodeY)
        }
    }

    var receiptOffsetY: CGFloat {
        Metric.hiddenReceiptOffsetY + (Metric.visibleReceiptOffsetY - Metric.hiddenReceiptOffsetY) * issueProgress
    }

    func startIssuingAnimationLoop() async {
        while !Task.isCancelled {
            await MainActor.run {
                issueProgress = 0
            }

            try? await Task.sleep(for: .milliseconds(Metric.initialDelayMilliseconds))

            await MainActor.run {
                withAnimation(.easeOut(duration: Metric.issueDuration)) {
                    issueProgress = 1
                }
            }

            try? await Task.sleep(for: .milliseconds(Metric.issueDurationMilliseconds + Metric.completionHoldMilliseconds))

            await MainActor.run {
                issueProgress = 0
            }

            try? await Task.sleep(for: .milliseconds(Metric.resetDelayMilliseconds))
        }
    }
}

private enum Metric {
    static let printerX: CGFloat = 0
    static let printerY: CGFloat = 0
    static let printerWidth: CGFloat = 156.6
    static let printerHeight: CGFloat = 36

    static let slotBridgeLineX: CGFloat = 20.3
    static let slotBridgeLineY: CGFloat = 17.35
    static let slotBridgeLineWidth: CGFloat = 117
    static let slotBridgeLineHeight: CGFloat = 1

    static let receiptX: CGFloat = 18.9
    static let receiptY: CGFloat = 16.2
    static let receiptWidth: CGFloat = 117
    static let receiptHeight: CGFloat = 163.8

    static let earthX: CGFloat = 42.3
    static let earthY: CGFloat = 45
    static let earthWidth: CGFloat = 68.4
    static let earthHeight: CGFloat = 66.6

    static let tearLineX: CGFloat = 26.1
    static let tearLineY: CGFloat = 135
    static let tearLineWidth: CGFloat = 102.6
    static let tearLineHeight: CGFloat = 0.5

    static let barcodeX: CGFloat = 29.79
    static let barcodeY: CGFloat = 146.67
    static let barcodeWidth: CGFloat = 97.57
    static let barcodeHeight: CGFloat = 18.23

    static let receiptClipY: CGFloat = 17.6
    static let hiddenReceiptOffsetY: CGFloat = -164
    static let visibleReceiptOffsetY: CGFloat = 0
    static let issueDuration = 3.2
    static let issueDurationMilliseconds = 3_200
    static let completionHoldMilliseconds = 1_500
    static let initialDelayMilliseconds = 250
    static let resetDelayMilliseconds = 350
}

#Preview {
    ReceiptLoadingIllustrationView()
        .padding()
        .background(Color.white)
}
