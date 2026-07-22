//
//  ArchiveReceipt.swift
//  JiguJagu
//
//

import UIKit

struct ArchiveReceipt: Identifiable {
    let id: String
    let brandName: String
    let productName: String
    let category: ArchiveCategory
    let subcategory: ArchiveSubcategory
    let productImageName: String
    let productImageURL: String?
    let localImage: UIImage?
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
        localImage: UIImage? = nil,
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
        self.localImage = localImage
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

    var archiveDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: registeredDate)
    }

    var maxMaterialPercentage: Int {
        materials.map(\.percentage).max() ?? 0
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

// MARK: - Clothing 변환

extension ArchiveReceipt {

    /// 등록 완료된 Clothing(랜덤 재질/날짜 포함)을 보관함 카드용 ArchiveReceipt로 변환합니다.
    /// - Parameter localImage: 누끼 딴 로컬 이미지 (카드에 우선 표시)
    init(from clothing: Clothing, localImage: UIImage? = nil) {
        let category = Self.archiveCategory(from: clothing.category3)

        self.init(
            id: clothing.id.uuidString,
            brandName: clothing.brand,
            productName: clothing.productName,
            category: category,
            subcategory: Self.archiveSubcategory(for: category, title: clothing.category4),
            productImageName: clothing.mockImageName ?? "MockProduct",
            productImageURL: clothing.productImageURL?.absoluteString,
            localImage: localImage,
            registeredDate: Date(),
            materials: clothing.materials,
            careTips: clothing.howToCare,
            washingGuides: clothing.washingGuides,
            tagNames: []
        )
    }

    /// 한글 대분류(상의/하의/아우터/그 외)를 ArchiveCategory로 변환합니다.
    private static func archiveCategory(from category3: String) -> ArchiveCategory {
        switch category3 {
        case let value where value.contains("상의"):
            return .tops
        case let value where value.contains("하의"):
            return .bottoms
        case let value where value.contains("아우터"):
            return .outers
        default:
            return .tops
        }
    }

    /// 세부 종류 제목을 해당 대분류의 ArchiveSubcategory로 매칭합니다. 실패 시 첫 항목으로 대체합니다.
    private static func archiveSubcategory(
        for category: ArchiveCategory,
        title: String
    ) -> ArchiveSubcategory {
        let candidates = category.subcategories
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)

        if let exact = candidates.first(where: { $0.title == trimmed }) {
            return exact
        }
        if !trimmed.isEmpty,
           let partial = candidates.first(where: {
               trimmed.contains($0.title) || $0.title.contains(trimmed)
           }) {
            return partial
        }
        return candidates.first ?? ArchiveSubcategory(id: "unknown", title: trimmed.isEmpty ? "그 외" : trimmed, category: category)
    }
}
