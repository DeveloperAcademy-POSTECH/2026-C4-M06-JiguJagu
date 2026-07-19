//
//  SearchResultGrid.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import SwiftUI

struct SearchResultGrid: View {
    
    let items: [Clothing]
    let columns: [GridItem]
    
    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: 21
        ) {
            ForEach(items) { item in
                ClothingCard(item: item)
            }
        }
    }
}
