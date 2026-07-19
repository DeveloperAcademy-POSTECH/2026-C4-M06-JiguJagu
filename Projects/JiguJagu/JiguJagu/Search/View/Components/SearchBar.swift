//
//  SearchBar.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI	

struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray)
            
            TextField(
                "브랜드명, 상품명을 입력하세요!",
                text: $text
            )
        }
        .padding(.horizontal, 14)
        .frame(width: 328, height: 42)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
