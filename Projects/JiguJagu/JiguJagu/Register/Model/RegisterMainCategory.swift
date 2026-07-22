//
//  RegisterMainCategory.swift
//  JiguJagu
//
//

import Foundation

enum RegisterMainCategory: String, CaseIterable, Identifiable {
    case tops
    case bottoms
    case outers
    case etc

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .tops:
            return "상의"
        case .bottoms:
            return "하의"
        case .outers:
            return "아우터"
        case .etc:
            return "그 외"
        }
    }

    var detailTitle: String {
        switch self {
        case .tops:
            return "상의의 종류를 골라주세요"
        case .bottoms:
            return "하의의 종류를 골라주세요"
        case .outers:
            return "아우터의 종류를 골라주세요"
        case .etc:
            return "제품명을 입력해주세요"
        }
    }

    var skipsDetailSelection: Bool {
        self == .etc
    }

    var subcategories: [RegisterSubcategory] {
        switch self {
        case .tops:
            return [
                RegisterSubcategory(id: "t-shirt", title: "티셔츠"),
                RegisterSubcategory(id: "pique-collar-shirt", title: "피케/카라티"),
                RegisterSubcategory(id: "hoodie", title: "후드"),
                RegisterSubcategory(id: "tops_mtm", title: "맨투맨"),
                RegisterSubcategory(id: "tops_sweatshirt_blouse", title: "셔츠/블라우스"),
                RegisterSubcategory(id: "tops_knit", title: "니트"),
                RegisterSubcategory(id: "tops_other", title: "그 외")
            ]
        case .bottoms:
            return [
                RegisterSubcategory(id: "jeans", title: "청바지"),
                RegisterSubcategory(id: "training-pants", title: "트레이닝팬츠"),
                RegisterSubcategory(id: "shorts", title: "숏팬츠"),
                RegisterSubcategory(id: "skirt-one-piece", title: "스커트/원피스"),
                RegisterSubcategory(id: "bottoms_other", title: "그 외"),
            ]
        case .outers:
            return [
                RegisterSubcategory(id: "zip-up", title: "집업"),
                RegisterSubcategory(id: "jacket", title: "재킷"),
                RegisterSubcategory(id: "coat", title: "코트"),
                RegisterSubcategory(id: "padded-jacket", title: "패딩"),
                RegisterSubcategory(id: "outers_cardigan", title: "가디건"),
                RegisterSubcategory(id: "tops_other", title: "그 외")
            ]
        case .etc:
            return []
        }
    }
}
