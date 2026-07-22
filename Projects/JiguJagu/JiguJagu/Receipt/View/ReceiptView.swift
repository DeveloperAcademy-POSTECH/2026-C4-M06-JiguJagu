//
//  ReceiptView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI
import UIKit
import Combine

enum ReceiptDisplayMode {
    case generated
    case archived

    var initialReceiptOffset: CGFloat {
        switch self {
        case .generated:
            return -1200
        case .archived:
            return 0
        }
    }

    var shouldStartPrinting: Bool {
        self == .generated
    }

    var allowsPrintSkip: Bool {
        self == .generated
    }
}

struct ReceiptView: View {
    
    let clothing: Clothing
    let localImage: UIImage?
    let displayMode: ReceiptDisplayMode
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    @State private var controller = ReceiptAnimationController()
    @State private var isPrinting = false
    @State private var showArchive = false
    @StateObject private var shareController = ReceiptShareController()

    init(
        clothing: Clothing,
        localImage: UIImage? = nil,
        displayMode: ReceiptDisplayMode = .generated
    ) {
        self.clothing = clothing
        self.localImage = localImage
        self.displayMode = displayMode
        _controller = State(
            initialValue: ReceiptAnimationController(
                receiptOffset: displayMode.initialReceiptOffset
            )
        )
    }
    
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
                startReceiptPresentationIfNeeded(proxy: proxy)
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
                skipReceiptPresentationIfNeeded(proxy: proxy)
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

private extension ReceiptView {
    func startReceiptPresentationIfNeeded(proxy: ScrollViewProxy) {
        guard displayMode.shouldStartPrinting else {
            return
        }

        controller.startPrinting(proxy: proxy)
    }

    func skipReceiptPresentationIfNeeded(proxy: ScrollViewProxy) {
        guard displayMode.allowsPrintSkip else {
            return
        }

        controller.skipPrinting(proxy: proxy)
    }
}

#Preview {
    ReceiptView(
        clothing: Clothing.mocks[0]
    )
}
