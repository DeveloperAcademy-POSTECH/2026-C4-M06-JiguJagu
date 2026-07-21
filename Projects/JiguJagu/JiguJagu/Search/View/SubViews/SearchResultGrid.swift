//
//  SearchResultGrid.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import SwiftUI

struct SearchResultGrid: View {
    
    let items: [Clothing]
    let onSelect: (Clothing) -> Void
    
    private let columns = [
        GridItem(.fixed(180), spacing: 10),
        GridItem(.fixed(180))
    ]
    
    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 21
        ) {
            ForEach(items) { item in
                ClothingCard(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("상품 선택:", item.productName)
                        onSelect(item)
                    }
            }
        }
    }
}
