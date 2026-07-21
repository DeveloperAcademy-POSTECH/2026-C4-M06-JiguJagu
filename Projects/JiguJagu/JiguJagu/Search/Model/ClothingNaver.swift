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

    /// 네이버 쇼핑 title의 HTML 태그 제거

    func strippingHTML() -> String {

        var result = self

        // <b> 태그 제거

        result = result.replacingOccurrences(

            of: "<[^>]+>",
            with: "",
            options: .regularExpression

        )

        // HTML Entity 변환

        let entities: [String: String] = [

            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&#39;": "'",
            "&apos;": "'",
            "&nbsp;": " "

        ]

        for (key, value) in entities {
            result = result.replacingOccurrences(
                of: key,
                with: value
            )
        }

        return result.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

}

// MARK: - Item 편의 프로퍼티

extension NaverShoppingItem {

    /// 화면 표시용 상품명
    var cleanedTitle: String {
        title.strippingHTML()
    }

    /// 브랜드가 없을 경우 빈 문자열 반환

    var displayBrand: String {
        brand.isEmpty ? "알 수 없음" : brand
    }

}

// MARK: - 분석 결과 → 검색 쿼리

struct ClothingAnalysis: Hashable {

    let brand: String?
    let category: String?
    let keywords: [String]

}

extension ClothingAnalysis {

    /// 네이버 쇼핑 검색어 생성

    func makeSearchQuery() -> String {

        if let keyword = keywords.first(where: { !$0.isEmpty }) {
            return keyword
        }

        return [
            brand,
            category
        ]
        .compactMap { $0 }
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
