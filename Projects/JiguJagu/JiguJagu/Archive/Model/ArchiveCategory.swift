//
//  ArchiveCategory.swift
//  JiguJagu
//
//

import Foundation

enum ArchiveCategory: String, CaseIterable, Identifiable {
    case all
    case tops
    case bottoms
    case outers

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .tops:
            return "Tops"
        case .bottoms:
            return "Bottoms"
        case .outers:
            return "Outers"
        }
    }

    var subcategories: [ArchiveSubcategory] {
        switch self {
        case .all:
            return []
        case .tops:
            return ArchiveSubcategory.tops
        case .bottoms:
            return ArchiveSubcategory.bottoms
        case .outers:
            return ArchiveSubcategory.outers
        }
    }
    
    var displayName: String {
        switch self {
        case .all:
            return "전체"
        case .tops:
            return "상의"
        case .bottoms:
            return "하의"
        case .outers:
            return "아우터"
        }
    }
}
