//
//  ProductSearchResultView.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//

import SwiftUI

struct ProductSearchResultView: View {
    
    let analysis: ClothingAnalysis
    let items: [Clothing]
    let searchErrorMessage: String?
    let shouldSearchInitialQuery: Bool
    
    init(
        analysis: ClothingAnalysis,
        items: [Clothing] = [],
        searchErrorMessage: String? = nil,
        shouldSearchInitialQuery: Bool = true
    ) {
        self.analysis = analysis
        self.items = items
        self.searchErrorMessage = searchErrorMessage
        self.shouldSearchInitialQuery = shouldSearchInitialQuery
    }
    
    var body: some View {
        SearchView(
            items: items,
            initialQuery: analysis.makeSearchQuery(), // GPT 분석 결과만 넘김
            searchErrorMessage: searchErrorMessage,
            shouldSearchInitialQuery: shouldSearchInitialQuery
        )
    }
}
