//
//  Clothing.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

// 네이버 쇼핑 API 받는 모델
import Foundation


/// 네이버 쇼핑 API 응답 모델
struct NaverShoppingItem: Decodable {
    let title: String
    let image: URL?
    let brand: String
    let category3: String
    let category4: String
}

/// 앱에서 사용하는 의류 모델
struct Clothing: Identifiable {
    let id = UUID()

    let brand: String
    let productName: String

    let mockImageName: String? // TODO: Mock 데이터 전용 (추후 삭제)
    let productImageURL: URL?

    let category3: String
    let category4: String

    let howToCare: [String]
    let washingGuides: [WashingGuide]
    let materials: [Material]
}

extension Clothing {
    init(from item: NaverShoppingItem,
         mockImageName: String? = nil,
         howToCare: [String] = [],
         washingGuides: [WashingGuide] = [],
         materials: [Material] = []) {
        self.brand = item.brand
        self.productName = item.title
        self.mockImageName = mockImageName
        self.productImageURL = item.image
        self.category3 = item.category3
        self.category4 = item.category4
        self.howToCare = howToCare
        self.washingGuides = washingGuides
        self.materials = materials
    }
}
