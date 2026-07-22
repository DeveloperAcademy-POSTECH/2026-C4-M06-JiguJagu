//
//  Clothing+Identification.swift
//  JiguJagu
//
//  옷 분석 결과(ClothingIdentification)를 등록 화면용 Clothing으로 변환합니다.
//

import Foundation

extension Clothing {

    /// 분석 결과를 등록 화면(RegisterConfirmView)에서 쓸 Clothing으로 변환합니다.
    /// - category3: RegisterConfirmView가 한글 키워드로 대분류를 판정하므로 한글 대분류를 넣습니다.
    /// - category4: 분석 세부 종류(예: "재킷")를 그대로 넣어 세부 카테고리 매칭에 사용합니다.
    init(from identification: ClothingIdentification) {
        self.brand = identification.displayBrand ?? ""
        self.productName = identification.itemName
        self.mockImageName = nil
        self.productImageURL = nil
        self.category3 = Self.mainCategoryKeyword(from: identification.category)
        self.category4 = identification.subCategory
        self.receiptCategory = ""
        self.howToCare = []
        self.washingGuides = []
        self.materials = []
    }

    /// 분석 대분류 코드(TOP/BOTTOM/OUTER/ETC)를 등록 화면이 이해하는 한글 대분류로 변환합니다.
    private static func mainCategoryKeyword(from category: String) -> String {
        switch category.uppercased() {
        case "TOP", "TOPS":
            return "상의"
        case "BOTTOM", "BOTTOMS":
            return "하의"
        case "OUTER", "OUTERS":
            return "아우터"
        default:
            return "그 외"
        }
    }
}
