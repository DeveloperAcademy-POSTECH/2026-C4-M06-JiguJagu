//
//  SearchView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText: String
    @State private var submittedSearchText: String
    @State private var items: [Clothing]
    @State private var isSearching = false
    
    private let initialQuery: String?
    
    init(items: [Clothing] = [], initialQuery: String? = nil) {
        _items = State(initialValue: items)
        _searchText = State(initialValue: initialQuery ?? "")
        _submittedSearchText = State(initialValue: initialQuery ?? "")
        self.initialQuery = initialQuery
    }
    
    private var filteredItems: [Clothing] {
        guard !submittedSearchText.isEmpty else {
            return items
        }
        
        return items.filter {
            $0.brand.localizedCaseInsensitiveContains(submittedSearchText) ||
            $0.productName.localizedCaseInsensitiveContains(submittedSearchText)
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {
                        Color.clear
                            .frame(height: 0)
                            .id("top")
                        
                        searchBar()
                        
                        SearchResultSummary(
                            count: filteredItems.count,
                            action: {}
                        )
                        
                        if filteredItems.isEmpty {
                            Text("검색 결과가 없습니다.")
                                .font(Font.pretendard.head3)
                                .foregroundStyle(Color.grayScale600)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 280)
                        } else {
                            SearchResultGrid(
                                items: filteredItems
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
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
        .navigationBarBackButtonHidden(true)
        .task {
            if let initialQuery, !initialQuery.isEmpty {
                await searchNaver(query: initialQuery)
            }
        }
    }
}

private extension SearchView {
    
    @ViewBuilder
    func searchBar() -> some View {
        SearchTopBar(
            searchText: $searchText,
            onSearch: {
                submittedSearchText = searchText
                Task {
                    await searchNaver(query: searchText)
                }
            }
        )
    }
    
    func searchNaver(query: String) async {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        submittedSearchText = query
        
        guard !query.isEmpty else {
            return
        }
        
        isSearching = true
        
        do {
            let service = NaverShoppingService(
                clientID: try APIConfig.naverClientID,
                clientSecret: try APIConfig.naverClientSecret
            )
            
            let results = try await service.search(
                query: query,
                display: 10
            )
            
            items = results.map(Clothing.init(from:))
        } catch {
            print("네이버 검색 실패:", error.localizedDescription)
        }
        
        isSearching = false
    }
    
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
        items: [],
        initialQuery: "칼하트 디트로이트 재킷"
    )
}
