//
//  ReceiptView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI
import UIKit

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
                        onArchive: { showArchive = true }
                    )
                }
                ScrollView(showsIndicators: false) {
                    
                    ZStack(alignment: .top) {
                        
                        VStack(spacing: 0) {
                            
                            VStack(spacing: 24) {
                                Image("BrownLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 99.8, height: 18.85)
                                    .padding(.top, 20)
                                
                                VStack(spacing: 10.66) {
                                    Image("StarDevider")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 291.78, height: 3.66)
                                    
                                    Text("GOOD FOR EARTH * GOOD FOR ENVIRONMENT")
                                        .font(Font.arrayFont.sub2)
                                    
                                    Image("StarDevider")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 291.78, height: 3.66)
                                    
                                    
                                        .font(.caption)
                                }
                                
                                VStack(spacing: 3) {
                                    InfoSection(
                                        category: "[ \(clothing.category3) > \(clothing.category4) ]",
                                        brandName: clothing.brand,
                                        productName: clothing.productName,
                                        productImageURL: clothing.productImageURL?.absoluteString,
                                        mockImageName: clothing.mockImageName,
                                        localImage: localImage
                                    )
                                    
                                    HowToCareSection(
                                        careTips: clothing.howToCare
                                    )
                                }
                                
                                Divider().background(Color.brown700)
                                
                                WashingGuideSection(
                                    guides: clothing.washingGuides
                                )
                                
                                Divider().background(Color.brown700)
                                
                                MaterialCompositionSection(
                                    materials: clothing.materials
                                )
                                
                                Divider().background(Color.brown700)
                                
                                FooterSection(
                                    date: formatter.string(from: Date()),
                                    category: "\(clothing.category3) > \(clothing.category4)"
                                )
                            }
                            .padding(
                                EdgeInsets(
                                    top: 12,
                                    leading: 12,
                                    bottom: 20,
                                    trailing: 12
                                )
                            )
                            .frame(width: 306)
                            .background(Color(Color.BG))
                            
                            Image("ReceiptBottom")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 306)
                        }
                        .offset(y: controller.receiptOffset)
                    }
                    .clipped()
                    .id("receiptBottom")
                    
                }
                .padding(.vertical)
            }
            .scrollBounceBehavior(.basedOnSize)
            .background {
                
                Image("MainBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 532, height: 912)
                    .clipped()
                    .opacity(0.6)
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
            .onAppear {
                controller.startPrinting(proxy: proxy)
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
