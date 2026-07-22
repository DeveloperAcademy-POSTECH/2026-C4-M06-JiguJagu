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
    @State private var selectedItem: Clothing?
    @State private var searchErrorMessage: String?
    
    private let initialQuery: String?
    private let shouldSearchInitialQuery: Bool
    
    init(
        items: [Clothing] = [],
        initialQuery: String? = nil,
        searchErrorMessage: String? = nil,
        shouldSearchInitialQuery: Bool? = nil
    ) {
        _items = State(initialValue: items)
        _searchText = State(initialValue: initialQuery ?? "")
        _submittedSearchText = State(initialValue: initialQuery ?? "")
        _searchErrorMessage = State(initialValue: searchErrorMessage)
        self.initialQuery = initialQuery
        self.shouldSearchInitialQuery = shouldSearchInitialQuery ?? items.isEmpty
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
        NavigationStack {
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
                            
                            if isSearching {
                                searchProgressView
                            } else if filteredItems.isEmpty {
                                emptyStateView
                            } else {
                                SearchResultGrid(
                                    items: filteredItems,
                                    onSelect: { item in
                                        selectedItem = item
                                    }
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
                .navigationDestination(isPresented: Binding(
                    get: { selectedItem != nil },
                    set: { if !$0 { selectedItem = nil } }
                )) {
                    if let item = selectedItem {
                        RegisterConfirmView(
                            clothing: item
                        )
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .task {
                if shouldSearchInitialQuery,
                   let initialQuery,
                   !initialQuery.isEmpty {
                    await searchNaver(query: initialQuery)
                }
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

    var searchProgressView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .tint(Color.primary500)

            Text("상품을 검색하고 있어요...")
                .font(Font.pretendard.head3)
                .foregroundStyle(Color.grayScale600)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 260)
    }

    var emptyStateView: some View {
        VStack(spacing: 10) {
            Text(searchErrorMessage ?? "검색 결과가 없습니다.")
                .font(Font.pretendard.head3)
                .foregroundStyle(Color.grayScale600)
                .multilineTextAlignment(.center)

            if searchErrorMessage != nil {
                Text("검색어를 수정해 다시 시도해 주세요.")
                    .font(Font.pretendard.body5)
                    .foregroundStyle(Color.grayScale500)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 260)
    }
    
    func searchNaver(query: String) async {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        submittedSearchText = query
        
        guard !query.isEmpty else {
            return
        }
        
        isSearching = true
        searchErrorMessage = nil
        
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
            items = []
            searchErrorMessage = "상품 검색에 실패했어요."
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
        initialQuery: "버버리"
    )
}
