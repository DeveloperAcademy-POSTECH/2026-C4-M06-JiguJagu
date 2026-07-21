//
//  ClothingNaver.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//
//  네이버 쇼핑 API 결과를 앱의 Clothing 모델로 변환하는 계층
//

import Foundation

// MARK: - String HTML 정제

extension String {
    /// <b> 등 HTML 태그 제거 + 대표 HTML 엔티티 디코딩
    func strippingHTML() -> String {
        var result = self
        // 1) 모든 태그 제거 (<b>, </b>, 기타)
        result = result.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
        // 2) 대표적인 HTML 엔티티 디코딩
        let entities: [String: String] = [
            "&amp;": "&", "&lt;": "<", "&gt;": ">",
            "&quot;": "\"", "&#39;": "'", "&apos;": "'", "&nbsp;": " "
        ]
        for (key, value) in entities {
            result = result.replacingOccurrences(of: key, with: value)
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Item 편의 프로퍼티

extension NaverShoppingItem {
    /// 화면에 표시할 순수 상품명 (태그/엔티티 제거)
    var cleanedTitle: String {
        title.strippingHTML()
    }

    /// 화면 표시용 브랜드: brand 우선, 없으면 maker → mallName 순으로 대체
    var displayBrand: String {
        if !brand.isEmpty { return brand }
        if !maker.isEmpty { return maker }
        return mallName
    }
}

// MARK: - Clothing 매핑

extension Clothing {
    /// 네이버 쇼핑 결과 1건을 Clothing 으로 변환
    /// (Clothing 의 productImageURL 타입이 URL? 이라고 가정. String? 이라면 item.image 를 그대로 넣으세요)
    init(from item: NaverShoppingItem) {
        self.init(
            brand: item.displayBrand,
            productName: item.cleanedTitle,
            productImageURL: URL(string: item.image)
        )
    }
}

// MARK: - 분석 결과 → 검색 쿼리

/// 두 번째 화면(상품 분석 결과)에서 뽑아낸 값들
struct ClothingAnalysis: Hashable {
    let brand: String?         // 예: "칼하트"
    let category: String?      // 예: "재킷"
    let keywords: [String]     // 예: ["칼하트 디트로이트 재킷", "칼하트 브라운 워크 재킷", ...]
}

extension ClothingAnalysis {
    /// 네이버 쇼핑 검색용 쿼리 생성
    /// 전략: 분석이 만들어준 키워드가 가장 구체적이므로 1순위로 사용,
    ///       없으면 브랜드 + 카테고리 조합으로 폴백
    func makeSearchQuery() -> String {
        if let first = keywords.first(where: { !$0.isEmpty }) {
            return first
        }
        return [brand, category]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}

// MARK: - 사용 예시

/*
 let service = NaverShoppingService(
     clientID: "YOUR_CLIENT_ID",
     clientSecret: "YOUR_CLIENT_SECRET"
 )

 let analysis = ClothingAnalysis(
     brand: "칼하트",
     category: "재킷",
     keywords: [
         "칼하트 디트로이트 재킷",
         "칼하트 브라운 워크 재킷",
         "코튼 캔버스 집업 재킷"
     ]
 )

 Task {
     do {
         let items = try await service.search(
             query: analysis.makeSearchQuery(),
             display: 10                      // 10개 뽑기
         )
         let clothes = items.map(Clothing.init(from:))
         // → 이 clothes 를 첫 번째 화면 그리드에 바인딩
     } catch {
         print("검색 실패:", error.localizedDescription)
     }
 }
*/
