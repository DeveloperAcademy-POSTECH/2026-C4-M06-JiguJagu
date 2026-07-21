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
    let productImageURL: String?
    let registeredDate: Date
    let materials: [Material]
    let careTips: [String]
    let washingGuides: [WashingGuide]
    let tagNames: [String]

    init(
        id: String,
        brandName: String,
        productName: String,
        category: ArchiveCategory,
        subcategory: ArchiveSubcategory,
        productImageName: String,
        productImageURL: String? = nil,
        registeredDate: Date,
        materials: [Material],
        careTips: [String] = [],
        washingGuides: [WashingGuide] = [],
        tagNames: [String] = []
    ) {
        self.id = id
        self.brandName = brandName
        self.productName = productName
        self.category = category
        self.subcategory = subcategory
        self.productImageName = productImageName
        self.productImageURL = productImageURL
        self.registeredDate = registeredDate
        self.materials = materials
        self.careTips = careTips
        self.washingGuides = washingGuides
        self.tagNames = tagNames
    }

    var categoryPath: String {
        "\(category.title) > \(subcategory.title)"
    }

    var receiptCategoryText: String {
        "[ \(categoryPath) ]"
    }

    var footerTagText: String {
        tagNames.map { "#\($0)" }.joined(separator: " ")
    }

    var footerDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd-MMMM-yyyy"
        return formatter.string(from: registeredDate)
    }

    var searchKeywords: [String] {
        [brandName, productName, category.title, subcategory.title] + materials.map(\.name) + tagNames
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
