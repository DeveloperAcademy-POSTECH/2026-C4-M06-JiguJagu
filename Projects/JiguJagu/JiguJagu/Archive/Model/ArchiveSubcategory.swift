//
//  ArchiveSubcategory.swift
//  JiguJagu
//
//

import Foundation

struct ArchiveSubcategory: Identifiable, Equatable {
    let id: String
    let title: String
    let category: ArchiveCategory
}

extension ArchiveSubcategory {
    static let all: [ArchiveSubcategory] = tops + bottoms + outers

    static let tops: [ArchiveSubcategory] = [
        ArchiveSubcategory(id: "tops_tshirt", title: "티셔츠", category: .tops),
        ArchiveSubcategory(id: "tops_pique", title: "피케/카라티", category: .tops),
        ArchiveSubcategory(id: "tops_hoodie", title: "후드", category: .tops),
        ArchiveSubcategory(id: "tops_hoodie", title: "맨투맨", category: .tops),
        ArchiveSubcategory(id: "tops_hoodie", title: "셔츠/블라우스", category: .tops),
        ArchiveSubcategory(id: "tops_sweatshirt_blouse", title: "니트", category: .tops),
        ArchiveSubcategory(id: "tops_other", title: "그 외", category: .tops)
    ]

    static let bottoms: [ArchiveSubcategory] = [
        ArchiveSubcategory(id: "bottoms_jeans", title: "청바지", category: .bottoms),
        ArchiveSubcategory(id: "bottoms_training_pants", title: "트레이닝팬츠", category: .bottoms),
        ArchiveSubcategory(id: "bottoms_shorts", title: "숏팬츠", category: .bottoms),
        ArchiveSubcategory(id: "bottoms_skirt_dress", title: "스커트/원피스", category: .bottoms),
        ArchiveSubcategory(id: "bottoms_other", title: "그 외", category: .bottoms),
    ]

    static let outers: [ArchiveSubcategory] = [
        ArchiveSubcategory(id: "outers_jacket", title: "집업", category: .outers),
        ArchiveSubcategory(id: "outers_jacket", title: "재킷", category: .outers),
        ArchiveSubcategory(id: "outers_coat", title: "코트", category: .outers),
        ArchiveSubcategory(id: "outers_padding", title: "패딩", category: .outers),
        ArchiveSubcategory(id: "outers_cardigan", title: "가디건", category: .outers),
        ArchiveSubcategory(id: "tops_other", title: "그 외", category: .tops)
    ]
}
