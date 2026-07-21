//
//  ReceiptAnimationController.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI
import Observation

@Observable
final class ReceiptAnimationController {
    
    var receiptOffset: CGFloat = -1200
    var hasScrolled = false
    var shouldSkipPrinting = false
    var isSkipping = false
    
    func startPrinting(proxy: ScrollViewProxy) {
        
        Task {

            while receiptOffset < 0 && !shouldSkipPrinting {
                try? await Task.sleep(for: .milliseconds(50))

                await MainActor.run {
                    let nextOffset = min(
                        receiptOffset + CGFloat.random(in: 18...25),
                        0
                    )

                    withAnimation(.linear(duration: 0.03)) {
                        receiptOffset = nextOffset
                    }
                }
            }

            await MainActor.run {
                guard !isSkipping else { return }
                withAnimation(.easeOut(duration: 0.2)) {
                    receiptOffset = 0
                }
            }

            try? await Task.sleep(for: .milliseconds(200))

            await MainActor.run {
                proxy.scrollTo(
                    "receiptBottom",
                    anchor: .bottom
                )
            }
        }
    }
    
    func skipPrinting(proxy: ScrollViewProxy) {
        
        shouldSkipPrinting = true
        isSkipping = true
        hasScrolled = true
        
        withAnimation(.easeOut(duration: 0.2)) {
            receiptOffset = 0
        }
        
        DispatchQueue.main.async {
            proxy.scrollTo(
                "receiptBottom",
                anchor: .bottom
            )
        }
    }
}
