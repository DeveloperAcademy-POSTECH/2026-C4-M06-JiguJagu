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
        HStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Color.grayScale400)

            TextField("검색", text: $searchText)
                .font(.pretendard.head2)
                .foregroundStyle(Color.grayScale900)
                .tint(Color.primary500)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.grayScale400)
                        .frame(width: 32, height: 32)
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 78)
        .background(Color.grayScale100)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
