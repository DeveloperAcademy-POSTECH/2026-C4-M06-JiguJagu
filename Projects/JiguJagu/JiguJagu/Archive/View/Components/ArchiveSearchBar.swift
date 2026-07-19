//
//  ArchiveSearchBar.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct ArchiveSearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.grayScale400)

            TextField("검색", text: $searchText)
                .font(.pretendard.head5)
                .foregroundStyle(Color.grayScale900)
                .tint(Color.primary500)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.grayScale400)
                        .frame(width: 28, height: 28)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 39)
        .background(Color.grayScale100)
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
