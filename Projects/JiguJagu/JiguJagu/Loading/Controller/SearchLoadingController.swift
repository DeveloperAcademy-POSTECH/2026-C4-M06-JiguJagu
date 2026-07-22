//
//  SearchLoadingController.swift
//  JiguJagu
//
//  Created by Codex on 7/22/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchLoadingController {
    private(set) var items: [Clothing] = []
    private(set) var errorMessage: String?
    private(set) var isReady = false
    private(set) var isLoading = false

    let analysis: ClothingAnalysis

    var query: String {
        analysis.makeSearchQuery()
    }

    init(analysis: ClothingAnalysis) {
        self.analysis = analysis
    }

    func loadSearchResults() async {
        guard !isLoading, !isReady else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
            isReady = true
        }

        do {
            let service = NaverShoppingService(
                clientID: try APIConfig.naverClientID,
                clientSecret: try APIConfig.naverClientSecret
            )

            let results = try await service.search(
                query: query,
                display: 10
            )

            items = results.map(Clothing.init(from:))
        } catch {
            errorMessage = error.localizedDescription
            items = []
        }
    }
}
