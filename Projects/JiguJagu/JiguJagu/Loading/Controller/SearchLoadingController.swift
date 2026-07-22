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
    private static let minimumLoadingNanoseconds: UInt64 = 3_000_000_000

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

        async let minimumLoading: Void = waitMinimumLoadingDuration()
        async let searchResult: Result<[Clothing], Error> = fetchSearchResults()

        let result = await searchResult
        await minimumLoading

        applySearchResult(result)
        isLoading = false
        isReady = true
    }
}

private extension SearchLoadingController {
    nonisolated func waitMinimumLoadingDuration() async {
        try? await Task.sleep(nanoseconds: Self.minimumLoadingNanoseconds)
    }

    nonisolated func fetchSearchResults() async -> Result<[Clothing], Error> {
        do {
            let service = NaverShoppingService(
                clientID: try APIConfig.naverClientID,
                clientSecret: try APIConfig.naverClientSecret
            )

            let results = try await service.search(
                query: query,
                display: 10
            )

            return .success(results.map(Clothing.init(from:)))
        } catch {
            return .failure(error)
        }
    }

    func applySearchResult(_ result: Result<[Clothing], Error>) {
        switch result {
        case let .success(items):
            self.items = items
            errorMessage = nil
        case let .failure(error):
            self.items = []
            errorMessage = error.localizedDescription
        }
    }
}
