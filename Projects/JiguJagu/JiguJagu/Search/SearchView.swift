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
                        
                        SearchTopBar()
                        
                        SearchResultSummary(
                            count: items.count,
                            action: {}
                        )
                        
                        SearchResultGrid(
                            items: items,
                            columns: columns
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                
                BottomGradientOverlay()
                
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
        withAnimation(.easeInOut(duration: 0.5)) {
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
