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
                .foregroundStyle(Color.grayScale300)
            
            TextField(
                "브랜드명, 상품명을 입력하세요!",
                text: $text
            )
            .font(Font.pretendard.body5)
            .foregroundStyle(Color.grayScale500)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.grayScale300)
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(width: 328, height: 42)
        .background(Color.grayScale100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
