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
    private static let initialLoadingProgress = 0.2
    private static let maximumWaitingProgress = 0.92
    private static let loadingProgressIncrement = 0.012
    private static let loadingProgressTickNanoseconds: UInt64 = 80_000_000
    private static let completionPauseNanoseconds: UInt64 = 180_000_000

    private(set) var items: [Clothing] = []
    private(set) var errorMessage: String?
    private(set) var isReady = false
    private(set) var isLoading = false
    private(set) var progress = initialLoadingProgress

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
        progress = Self.initialLoadingProgress
        let progressTask = Task {
            await runSearchProgressLoop()
        }

        async let minimumLoading: Void = waitMinimumLoadingDuration()
        async let searchResult: Result<[Clothing], Error> = fetchSearchResults()

        let result = await searchResult
        await minimumLoading

        progressTask.cancel()
        applySearchResult(result)
        progress = 1
        try? await Task.sleep(nanoseconds: Self.completionPauseNanoseconds)
        isLoading = false
        isReady = true
    }
}

private extension SearchLoadingController {
    nonisolated func waitMinimumLoadingDuration() async {
        try? await Task.sleep(nanoseconds: Self.minimumLoadingNanoseconds)
    }

    func fetchSearchResults() async -> Result<[Clothing], Error> {
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
        case .failure:
            self.items = []
            errorMessage = "상품 검색에 실패했어요."
        }
    }

    func runSearchProgressLoop() async {
        while !Task.isCancelled {
            guard progress < Self.maximumWaitingProgress else {
                try? await Task.sleep(nanoseconds: Self.loadingProgressTickNanoseconds)
                continue
            }

            progress = min(
                progress + Self.loadingProgressIncrement,
                Self.maximumWaitingProgress
            )

            try? await Task.sleep(nanoseconds: Self.loadingProgressTickNanoseconds)
        }
    }
}
