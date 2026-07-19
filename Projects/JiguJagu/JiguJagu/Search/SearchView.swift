//
//  SearchView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    
    let items: [Clothing]
    
    private var filteredItems: [Clothing] {
        guard !searchText.isEmpty else {
            return items
        }
        
        return items.filter {
            $0.brand.localizedCaseInsensitiveContains(searchText) ||
            $0.productName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                if filteredItems.isEmpty {
                    VStack(spacing: 20) {
                        Color.clear
                            .frame(height: 0)
                        
                        SearchTopBar(searchText: $searchText)
                        
                        SearchResultSummary(
                            count: 0,
                            action: {}
                        )
                        
                        GeometryReader { geometry in
                            Text("검색 결과가 없습니다")
                                .font(Font.pretendard.head3)
                                .foregroundStyle(Color.grayScale600)
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            Color.clear
                                .frame(height: 0)
                                .id("top")
                            
                            SearchTopBar(
                                searchText: $searchText
                            )
                            
                            SearchResultSummary(
                                count: filteredItems.count,
                                action: {}
                            )
                            
                            SearchResultGrid(
                                items: filteredItems
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
                
                if !filteredItems.isEmpty {
                    BottomGradientOverlay()
                }
                
                FloatingUpButton {
                    scrollToTop(proxy)
                }
                .padding(.trailing, 35.5)
                .padding(.bottom, 33)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

private extension SearchView {
    
    func scrollToTop(_ proxy: ScrollViewProxy) {
        withAnimation(.easeInOut(duration: 0.25)) {
            proxy.scrollTo(
                "top",
                anchor: .top
            )
        }
    }
}

#Preview {
    SearchView(
        items: Clothing.mocks
    )
}
