//
//  ProductSearchResultView.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//
//  위치: Search/ProductSearchResultView.swift
//  분석 결과(ClothingAnalysis)로 네이버 쇼핑을 검색해
//  결과 그리드(SearchView)로 이어주는 화면.
//

import SwiftUI

struct ProductSearchResultView: View {

    let analysis: ClothingAnalysis

    @State private var items: [Clothing] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    private let service = NaverShoppingService(
        clientID: APIConfig.naverClientID,
        clientSecret: APIConfig.naverClientSecret
    )

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
            let results = try await service.search(
                query: analysis.makeSearchQuery(),
                display: 10                     // 정확/유사 상품 10개
            )
            let mapped = results.map(Clothing.init(from:))
            items = mapped
            if mapped.isEmpty {
                errorMessage = "검색 결과가 없어요. 다른 각도로 다시 촬영해 보세요."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
