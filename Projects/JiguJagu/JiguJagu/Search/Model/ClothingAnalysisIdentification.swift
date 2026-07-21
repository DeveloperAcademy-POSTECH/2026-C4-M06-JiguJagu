//
//  ClothingAnalysisIdentification.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//
//  OpenAI 분석 결과(ClothingIdentification)를 네이버 검색용 값(ClothingAnalysis)으로 변환.
//

import Foundation

extension ClothingAnalysis {

    /// 분석 결과를 검색 쿼리용 값으로 변환합니다.
    /// - brand: 확정 브랜드 우선, 없으면 추측 브랜드
    /// - category: 세부 분류 (예: "재킷")
    /// - keywords: OpenAI가 만든 쇼핑 검색 키워드 (브랜드가 포함되어 있음)
    init(from identification: ClothingIdentification) {
        self.init(
            brand: identification.displayBrand,
            category: identification.subCategory,
            keywords: identification.searchKeywords
        )
    }
}
