//
//  ReceiptView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI
import UIKit
import Combine

struct ReceiptView: View {
    
    let clothing: Clothing
    var localImage: UIImage? = nil
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    @State private var controller = ReceiptAnimationController()
    @State private var isPrinting = false
    @State private var showArchive = false
    @StateObject private var shareController = ReceiptShareController()
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: -50) {
                
                ZStack(alignment: .top) {
                    
                    
                    Image("ReceiptPrinter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 355.72)
                        .padding(.top, 50)
                    
                    ReceiptTopActions(
                        shareImage: shareController.shareImage,
                        onArchive: { showArchive = true }
                    )
                }
                ScrollView(showsIndicators: false) {
                    
                    ZStack(alignment: .top) {
                        
                        ReceiptContentView(
                            clothing: clothing,
                            localImage: localImage,
                            formatter: formatter
                        )
                        .offset(y: controller.receiptOffset)
                    }
                    .clipped()
                    .id("receiptBottom")
                    
                }
                .padding(.vertical)
            }
            
            .scrollBounceBehavior(.basedOnSize)
            .background {
                ZStack(alignment: .top) {
                    Image("MainBG")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 532, height: 912)
                        .clipped()
                        .opacity(0.6)
                    
                    TopGradientOverlay()
                        .allowsHitTesting(false)
                }
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
            .onAppear {
                controller.startPrinting(proxy: proxy)
                DispatchQueue.main.async {
                    shareController.makeShareImage(
                        from: ReceiptContentView(
                            clothing: clothing,
                            localImage: localImage,
                            formatter: formatter
                        ),
                        size: CGSize(width: 306, height: 900)
                    )
                }
            }
            .onTapGesture {
                controller.skipPrinting(proxy: proxy)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showArchive) {
            ArchiveView(
                receipts: [ArchiveReceipt(from: clothing, localImage: localImage)],
                initialCategory: .all,
                onBackButtonTap: { showArchive = false }
            )
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ReceiptView(
        clothing: Clothing.mocks[0]
    )
}
