//
//  SearchTopBar.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import SwiftUI

struct SearchTopBar: View {
    
    @Binding var searchText: String
    
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 12) {
            
            Button {
                print("뒤로가기")
            } label: {
                Image(systemName: "arrow.backward")
                    .foregroundColor(Color.grayScale900)
            }
            
            SearchBar(
                text: $searchText,
                onSearch: onSearch
            )
        }
    }
}
