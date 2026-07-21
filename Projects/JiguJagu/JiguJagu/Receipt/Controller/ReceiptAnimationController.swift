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
    
    var receiptOffset: CGFloat = -1500
    var hasScrolled = false
    var shouldSkipPrinting = false
    var isSkipping = false
    
    func startPrinting(proxy: ScrollViewProxy) {
        
        Task {

            while receiptOffset < 0 && !shouldSkipPrinting {
                
                try? await Task.sleep(
                    for: .milliseconds(Int.random(in: 40...70))
                )
                
                await MainActor.run {
                    let nextOffset = min(
                        receiptOffset + CGFloat.random(in: 5...10),
                        0
                    )
                    
                    withAnimation(.linear(duration: 0.03)) {
                        receiptOffset = nextOffset
                    }
                }
                
                if receiptOffset > -700 && !hasScrolled {
                    hasScrolled = true
                    
                    await MainActor.run {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            proxy.scrollTo(
                                "receiptBottom",
                                anchor: .bottom
                            )
                        }
                    }
                }
            }
            
            await MainActor.run {
                guard !isSkipping else { return }
                withAnimation(.easeOut(duration: 0.2)) {
                    receiptOffset = 0
                }
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
            withAnimation(.easeInOut(duration: 1.25)) {
                proxy.scrollTo(
                    "receiptBottom",
                    anchor: .bottom
                )
            }
        }
    }
}
