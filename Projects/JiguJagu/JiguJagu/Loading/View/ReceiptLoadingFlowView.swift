//
//  ReceiptLoadingFlowView.swift
//  JiguJagu
//
//  Created by Codex on 7/22/26.
//

import SwiftUI
import UIKit

struct ReceiptLoadingFlowView: View {
    private static let minimumLoadingNanoseconds: UInt64 = 3_000_000_000
    private static let progressSteps = 60
    private static let initialProgress = 0.2
    private static let readyProgress = 0.96
    private static let completionPauseNanoseconds: UInt64 = 180_000_000

    let clothing: Clothing
    let localImage: UIImage?

    @State private var isReady = false
    @State private var progress = Self.initialProgress

    init(clothing: Clothing, localImage: UIImage? = nil) {
        self.clothing = clothing
        self.localImage = localImage
    }

    var body: some View {
        Group {
            if isReady {
                ReceiptView(
                    clothing: clothing,
                    localImage: localImage
                )
            } else {
                ReceiptLoadingView(progress: progress)
            }
        }
        .task {
            await fillProgressDuringMinimumLoading()
            progress = 1
            try? await Task.sleep(nanoseconds: Self.completionPauseNanoseconds)
            isReady = true
        }
    }
}

private extension ReceiptLoadingFlowView {
    func fillProgressDuringMinimumLoading() async {
        let stepDuration = Self.minimumLoadingNanoseconds / UInt64(Self.progressSteps)

        for step in 1...Self.progressSteps {
            guard !Task.isCancelled else {
                return
            }

            let progressRange = Self.readyProgress - Self.initialProgress
            let progressFraction = Double(step) / Double(Self.progressSteps)
            progress = Self.initialProgress + progressRange * progressFraction
            try? await Task.sleep(nanoseconds: stepDuration)
        }
    }
}
