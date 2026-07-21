//
//  ArchiveSearchBar.swift
//  JiguJagu
//
//

import SwiftUI

struct ArchiveSearchBar: View {
    @Binding var searchText: String

    var body: some View {
        SearchBar(text: $searchText)
    }
}
