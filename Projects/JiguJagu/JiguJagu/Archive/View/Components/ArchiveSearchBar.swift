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
        SearchBar(text: $searchText)
    }
}
