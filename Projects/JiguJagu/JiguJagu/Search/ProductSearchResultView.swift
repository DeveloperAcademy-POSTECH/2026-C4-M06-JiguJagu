//
//  ProductSearchResultView.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//

import SwiftUI

struct ProductSearchResultView: View {

    let analysis: ClothingAnalysis

    @State private var items: [Clothing] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if isLoading {
                loadingView
            } else if let errorMessage {
                errorView(errorMessage)
            } else {
                SearchView(items: items)
            }
        }
        .task { await load() }
    }

    // MARK: - States

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("비슷한 상품을 찾고 있어요…")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text("상품을 불러오지 못했어요")
                .font(.system(size: 17, weight: .semibold))
            Text(message)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("다시 시도") { Task { await load() } }
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Load

    private func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let service = try makeService()          // 키 누락 시 APIConfigError throw
            let results = try await service.search(
                query: analysis.makeSearchQuery(),
                display: 10                            // 정확/유사 상품 10개
            )
            let mapped = results.map(Clothing.init(from:))
            items = mapped
            if mapped.isEmpty {
                errorMessage = "검색 결과가 없어요. 다른 각도로 다시 촬영해 보세요."
            }
        } catch {
            // APIConfigError(키 누락) 또는 네트워크/디코딩 에러가 여기로 전달됨
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// 키가 설정돼 있지 않으면 APIConfigError 를 던진다.
    private func makeService() throws -> NaverShoppingService {
        NaverShoppingService(
            clientID: try APIConfig.naverClientID,
            clientSecret: try APIConfig.naverClientSecret
        )
    }
}
