//
//  SearchTopBar.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import SwiftUI

struct SearchTopBar: View {
    
    @Binding var searchText: String
    @Environment(\.dismiss) private var dismiss
    
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 12) {
            
            Button {
                dismiss()
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
