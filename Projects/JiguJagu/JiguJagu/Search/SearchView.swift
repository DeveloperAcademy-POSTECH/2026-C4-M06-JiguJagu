//
//  SearchView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct SearchView: View {
    
    let items: [Clothing]
    
    private let columns = [
        GridItem(.fixed(180), spacing: 10),
        GridItem(.fixed(180))
    ]
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Color.clear
                            .frame(height: 0)
                            .id("top")
                        
                        HStack(spacing: 12) {
                            Button {
                                print("뒤로가기")
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(.black)
                            }
                            
                            SearchBar()
                        }
                        
                        SearchResultHeader(
                            count: items.count,
                            action: {}
                        )
                        
                        LazyVGrid(
                            columns: columns,
                            spacing: 21
                        ) {
                            ForEach(items) { item in
                                ClothingCard(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                
                LinearGradient(
                    colors: [
                        .clear,
                        .gray.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 161)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .bottom)
                .allowsHitTesting(false)
                
                FloatingUpButton {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        proxy.scrollTo("top", anchor: .top)
                    }
                }
                .padding(.trailing, 35.5)
                .padding(.bottom, 33)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    SearchView(
        items: [
            Clothing(
                brand: "CHICKS",
                productName: "브러쉬드 더블 스트라이프 카라 니트",
                productImageURL: nil
            ),
            Clothing(
                brand: "ZARA",
                productName: "단가라 반팔 카라 티셔츠",
                productImageURL: nil
            ),
            Clothing(
                brand: "H&M",
                productName: "브라운 줄무늬 긴팔 니트",
                productImageURL: nil
            ),
            Clothing(
                brand: "MANGO",
                productName: "배색 긴팔 카라 티셔츠",
                productImageURL: nil
            ),
            Clothing(
                brand: "H&M",
                productName: "멀티 STRIPE 티셔츠",
                productImageURL: nil
            ),
            Clothing(
                brand: "UNIQLO",
                productName: "코튼 스트라이프 티셔츠",
                productImageURL: nil
            )
        ]
    )
}
