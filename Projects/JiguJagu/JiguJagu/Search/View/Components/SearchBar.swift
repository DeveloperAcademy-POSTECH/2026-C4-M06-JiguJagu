//
//  SearchBar.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    var placeholder: String = "브랜드명, 상품명을 입력하세요!"
    var width: CGFloat? = 328
    var onSearch: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 8) {
            Button {
                onSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.grayScale300)
            }
            
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.grayScale300)
            )
            .font(Font.pretendard.body5)
            .foregroundStyle(Color.grayScale500)
            .onSubmit {
                onSearch()
            }
            
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
        .frame(width: width, height: 42)
        .frame(maxWidth: width == nil ? .infinity : nil)
        .background(Color.grayScale100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
