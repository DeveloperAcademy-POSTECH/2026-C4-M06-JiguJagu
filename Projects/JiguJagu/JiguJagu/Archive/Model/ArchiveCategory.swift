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
            return "옷"
        case .tops:
            return "상의"
        case .bottoms:
            return "하의"
        case .outers:
            return "아우터"
        }
    }
}

extension ArchiveCategory {
    /// 홈 화면 카테고리 티켓(TOP/BOTTOM/OUTER/ALL)에서 아카이브 카테고리로 진입할 때 사용합니다.
    enum HomeTicket: String, CaseIterable, Identifiable {
        case top
        case bottom
        case outer
        case all
        
        var id: String {
            rawValue
        }
        
        /// 홈 티켓 버튼에 노출되는 제목입니다.
        var title: String {
            rawValue.uppercased()
        }
        
        /// 아카이브 화면에서 초기 선택될 카테고리입니다.
        var archiveCategory: ArchiveCategory {
            switch self {
            case .top:
                return .tops
            case .bottom:
                return .bottoms
            case .outer:
                return .outers
            case .all:
                return .all
            }
        }
    }
}
