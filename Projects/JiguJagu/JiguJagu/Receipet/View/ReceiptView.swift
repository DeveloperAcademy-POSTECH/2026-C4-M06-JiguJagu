//
//  ReceiptView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI
import UIKit

struct ReceiptView: View {
    
    @State private var controller = ReceiptAnimationController()
    @State private var isPrinting = false
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: -50) {
                ZStack(alignment: .top) {
                    Image("ReceiptPrinter")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 355.72)
                        .padding(.top, 50)
                    
                    ReceiptTopActions()
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
                                    
                                    Text("GOOD FOR EARTH • GOOD FOR ENVIRONMENT")
                                        .font(Font.arrayFont.sub2)
                                    
                                    Image("StarDevider")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 291.78, height: 3.66)
                                    
                                    
                                        .font(.caption)
                                }
                                
                                VStack(spacing: 3) {
                                    InfoSection(
                                        category: "[ 상의 > 니트 ]",
                                        brandName: "CHICKS",
                                        productName: "더블 스트라이프 카라 니트",
                                        productImageURL: "url"
                                    )
                                    
                                    HowToCareSection(
                                        careTips: [
                                            "니트는 옷걸이에 걸면 어깨가 튀어나오고 옷이 아래로 처지므로 말거나 접어서 서랍장에 보관하는 것이 좋습니다.",
                                            "습기가 없는 서랍장에 보관하고, 사이에 신문지를 끼워두면 습기와 좀벌레를 예방할 수 있습니다."
                                        ]
                                    )
                                }
                                
                                Divider().background(Color.brown700)
                                
                                WashingGuideSection(
                                    guides: [
                                        WashingGuide(
                                            id: "handwashonly",
                                            washingIcon: "HandwashOnly",
                                            washingDescription: "세탁 시 반드시 뒤집어서 30도씨의 중성세제를 사용하여 찬물로 단독 손 세탁을 하세요!"
                                        ),
                                        
                                        WashingGuide(
                                            id: "donotbleach",
                                            washingIcon: "DoNotBleach",
                                            washingDescription: "염소 표백제나 강력 효소 세제는 제품에 손상을 줄 수 있으니 삼가 주시길 바랍니다."
                                        ),
                                        
                                        WashingGuide(
                                            id: "iron",
                                            washingIcon: "Iron",
                                            washingDescription: "다림질 시에는 저온으로 맞춰서 진행해주시고, 의류 손상이 적게 천천히 다림질해주시길 바랍니다."
                                        ),
                                        
                                        WashingGuide(
                                            id: "dryinshade",
                                            washingIcon: "DryInShade",
                                            washingDescription: "건조기 사용 시 옷 형태나 컬러에 변형이 발생하니 자연 건조를 권장합니다."
                                        )
                                    ]
                                )
                                
                                Divider().background(Color.brown700)
                                
                                MaterialCompositionSection(
                                    materials: [
                                        Material(name: "Acrylic", percentage: 60),
                                        Material(name: "Polyester", percentage: 20),
                                        Material(name: "Wool", percentage: 15),
                                        Material(name: "Nylon", percentage: 5)
                                    ]
                                )
                                
                                Divider().background(Color.brown700)
                                
                                FooterSection(date: "28-July-2026", category: "상의 > 니트", tag: "#니트 #파랑 #줄무늬")
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
    }
}

#Preview {
    ReceiptView()
}
