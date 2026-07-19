//
//  ArchiveCategory.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
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
}
