//
//  ProductResultView.swift
//  JiguJagu
//
//  Created by SIA on 7/20/26.
//

import SwiftUI

/// 옷 사진을 분석해 상품 정보를 보여주는 화면.
struct ProductResultView: View {

    let image: UIImage?
    var onDone: () -> Void = {}

    @State private var result: ClothingIdentification?
    @State private var errorMessage: String?
    @State private var isLoading = true

    // ⚠️ 아래 API 키 관리 관련 주의사항은 파일 하단 참고
    private let service = ProductSearchService(apiKey: APIConfig.openAIKey)

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    loadingView
                } else if let result {
                    resultView(result)
                } else {
                    errorView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("상품 검색 결과")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료", action: onDone)
                }
            }
        }
        .task { await identify() }
    }

    // MARK: - States

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("옷을 분석하고 있어요…")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
    }

    private func resultView(_ item: ClothingIdentification) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 240)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.itemName)
                        .font(.system(size: 22, weight: .bold))
                    HStack(spacing: 8) {
                        tag(item.category)
                        if let brand = item.brand, !brand.isEmpty {
                            tag(brand)
                        }
                    }
                }

                Text(item.itemDescription)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                if !item.colors.isEmpty {
                    labeledRow("색상", values: item.colors)
                }

                if !item.searchKeywords.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("검색 키워드")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                        FlowKeywords(keywords: item.searchKeywords)
                    }
                }
            }
            .padding()
        }
    }

    private var errorView: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 36))
                .foregroundStyle(.orange)
            Text("분석에 실패했어요")
                .font(.system(size: 17, weight: .semibold))
            Text(errorMessage ?? "잠시 후 다시 시도해 주세요.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("다시 시도") {
                Task { await identify() }
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Components

    private func tag(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.15))
            .clipShape(Capsule())
    }

    private func labeledRow(_ label: String, values: [String]) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .leading)
            Text(values.joined(separator: ", "))
                .font(.system(size: 15))
        }
    }

    // MARK: - Action

    private func identify() async {
        isLoading = true
        errorMessage = nil
        result = nil

        guard let image else {
            errorMessage = "분석할 사진이 없습니다."
            isLoading = false
            return
        }
        do {
            result = try await service.identify(image: image)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

/// 키워드를 여러 줄로 자동 줄바꿈해 보여주는 간단한 flow 레이아웃.
private struct FlowKeywords: View {
    let keywords: [String]

    var body: some View {
        // iOS 16+ 에서 사용 가능한 간단한 wrap 레이아웃
        FlexibleWrap(items: keywords) { keyword in
            Text("#\(keyword)")
                .font(.system(size: 13))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())
        }
    }
}

/// 아이템을 가로로 채우다 넘치면 다음 줄로 넘기는 래퍼.
private struct FlexibleWrap<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        var width: CGFloat = 0
        var height: CGFloat = 0

        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geo.size.width {
                                width = 0
                                height -= d.height + 8
                            }
                            let result = width
                            if item == items.last { width = 0 } else { width -= d.width + 8 }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item == items.last { height = 0 }
                            return result
                        }
                }
            }
        }
        .frame(height: 80)
    }
}
