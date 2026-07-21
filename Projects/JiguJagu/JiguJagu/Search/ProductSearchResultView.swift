//
//  ProductSearchResultView.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//

import SwiftUI

struct ProductSearchResultView: View {
    
    let analysis: ClothingAnalysis
    
    var body: some View {
        SearchView(
            items: [],
            initialQuery: analysis.makeSearchQuery() // GPT 분석 결과만 넘김
        )
    }
}
