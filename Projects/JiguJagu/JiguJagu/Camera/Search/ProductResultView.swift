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

    /// 값이 설정되면 네이버 검색 결과 화면으로 push 된다.
    @State private var searchAnalysis: ClothingAnalysis?


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
            .navigationDestination(item: $searchAnalysis) { analysis in
                SearchLoadingFlowView(analysis: analysis)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        if let result {
                            searchAnalysis = ClothingAnalysis(from: result)
                        }
                    }
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

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.itemName)
                        .font(.system(size: 22, weight: .bold))

                    // 카테고리: 대분류 · 세부분류
                    HStack(spacing: 8) {
                        tag(item.categoryDisplayName)
                        tag(item.subCategory, highlighted: true)
                    }
                }

                // 브랜드 카드 (확정 또는 추측)
                if let brand = item.displayBrand {
                    brandCard(brand: brand, item: item)
                }

                Text(item.itemDescription)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                if let confidence = item.confidence {
                    confidenceRow("분석 신뢰도", value: confidence)
                }

                VStack(alignment: .leading, spacing: 10) {
                    if !item.colors.isEmpty {
                        labeledRow("색상", value: item.colors.joined(separator: ", "))
                    }
                    if let material = item.material, !material.isEmpty {
                        labeledRow("소재", value: material)
                    }
                    if let pattern = item.pattern, !pattern.isEmpty {
                        labeledRow("패턴", value: pattern)
                    }
                }

                if !item.searchKeywords.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("검색 키워드")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                        FlexibleWrap(items: item.searchKeywords) { keyword in
                            Text("#\(keyword)")
                                .font(.system(size: 13))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Capsule())
                        }
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

    /// 브랜드 표시 카드. 추측이면 "추측" 뱃지와 근거를 함께 보여준다.
    private func brandCard(brand: String, item: ClothingIdentification) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: "tag.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Text(brand)
                    .font(.system(size: 17, weight: .semibold))

                if item.isBrandGuessed {
                    Text("추측")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.15))
                        .clipShape(Capsule())
                } else {
                    Text("확인됨")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.15))
                        .clipShape(Capsule())
                }
                Spacer()
                if let bc = item.brandConfidence {
                    Text("\(Int((bc * 100).rounded()))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            if let reason = item.brandReason, !reason.isEmpty {
                Text(reason)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            if item.isBrandGuessed {
                Text("※ 로고가 확인되지 않아 디자인 특징으로 추측한 결과예요.")
                    .font(.system(size: 11))
                    .foregroundStyle(.orange.opacity(0.8))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func tag(_ text: String, highlighted: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(highlighted ? Color.white : Color.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(highlighted ? Color.accentColor : Color.gray.opacity(0.15))
            .clipShape(Capsule())
    }

    private func labeledRow(_ label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 44, alignment: .leading)
            Text(value)
                .font(.system(size: 15))
        }
    }

    private func confidenceRow(_ label: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int((value * 100).rounded()))%")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(value >= 0.7 ? .green : .orange)
            }
            ProgressView(value: value)
                .tint(value >= 0.7 ? .green : .orange)
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

// MARK: - Action

private extension ProductResultView {
    func identify() async {
        isLoading = true
        errorMessage = nil
        result = nil

        guard let image else {
            errorMessage = "분석할 사진이 없습니다."
            isLoading = false
            return
        }
        do {
            let service = try makeService()          // 키 누락 시 APIConfigError throw
            result = try await service.identify(image: image)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// 키가 설정돼 있지 않으면 APIConfigError 를 던진다.
    func makeService() throws -> ProductSearchService {
        ProductSearchService(apiKey: try APIConfig.openAIKey)
    }
}
