//
//  RegisterColorOption.swift
//  JiguJagu
//
//

import Foundation

enum RegisterColorOption: String, CaseIterable, Identifiable {
    case black
    case white
    case colored

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .black:
            return "검정색"
        case .white:
            return "흰색"
        case .colored:
            return "유색"
        }
    }

    var symbol: String {
        switch self {
        case .black:
            return "⚫️"
        case .white:
            return "⚪️"
        case .colored:
            return "🌈"
        }
    }
}
