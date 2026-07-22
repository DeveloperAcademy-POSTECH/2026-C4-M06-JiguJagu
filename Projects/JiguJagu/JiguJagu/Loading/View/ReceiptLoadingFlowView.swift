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

    let clothing: Clothing
    let localImage: UIImage?

    @State private var isReady = false

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
                ReceiptLoadingView()
            }
        }
        .task {
            await waitMinimumLoadingDuration()
            isReady = true
        }
    }
}

private extension ReceiptLoadingFlowView {
    func waitMinimumLoadingDuration() async {
        try? await Task.sleep(nanoseconds: Self.minimumLoadingNanoseconds)
    }
}

#Preview {
    ReceiptLoadingFlowView(
        clothing: Clothing.mocks[0]
    )
}
