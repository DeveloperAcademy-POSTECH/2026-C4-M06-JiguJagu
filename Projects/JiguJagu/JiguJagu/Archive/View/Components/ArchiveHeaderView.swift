//
//  ArchiveHeaderView.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct ArchiveHeaderView: View {
    @Binding var searchText: String
    let onBackButtonTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: onBackButtonTap) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(Color.grayScale900)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Image("BrownLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 44)
            }

            ArchiveSearchBar(searchText: $searchText)
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 8)
    }
}
