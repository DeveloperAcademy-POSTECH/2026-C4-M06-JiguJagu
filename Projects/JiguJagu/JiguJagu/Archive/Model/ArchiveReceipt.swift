//
//  ArchiveReceipt.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import Foundation

struct ArchiveReceipt: Identifiable {
    let id: String
    let brandName: String
    let productName: String
    let category: ArchiveCategory
    let subcategory: ArchiveSubcategory
    let productImageName: String
    let registeredDate: Date
    let materials: [Material]

    var categoryPath: String {
        "\(category.title) > \(subcategory.title)"
    }

    var searchKeywords: [String] {
        [brandName, productName, category.title, subcategory.title] + materials.map(\.name)
    }

    func retainedDays(relativeTo date: Date = Date(), calendar: Calendar = .current) -> Int {
        let days = calendar.dateComponents([.day], from: registeredDate, to: date).day ?? 0
        return max(days, 0)
    }

    func dDayText(relativeTo date: Date = Date(), calendar: Calendar = .current) -> String {
        "D+\(retainedDays(relativeTo: date, calendar: calendar))"
    }

    func keptDaysText(relativeTo date: Date = Date(), calendar: Calendar = .current) -> String {
        "함께한지 \(retainedDays(relativeTo: date, calendar: calendar))일째"
    }
}
