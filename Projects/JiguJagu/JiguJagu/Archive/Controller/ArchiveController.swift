//
//  ArchiveController.swift
//  JiguJagu
//
//

import Foundation
import Observation

@Observable
final class ArchiveController {
    var searchText = ""
    var selectedCategory: ArchiveCategory = .all
    var selectedSubcategory: ArchiveSubcategory?
    private(set) var receipts: [ArchiveReceipt]

    init(
        receipts: [ArchiveReceipt] = [],
        initialCategory: ArchiveCategory = .all
    ) {
        self.receipts = receipts
        self.selectedCategory = initialCategory
    }

    var categories: [ArchiveCategory] {
        ArchiveCategory.allCases
    }

    var availableSubcategories: [ArchiveSubcategory] {
        if selectedCategory == .all {
            return ArchiveSubcategory.all
        }

        return selectedCategory.subcategories
    }

    var filteredReceipts: [ArchiveReceipt] {
        receipts.filter { receipt in
            matchesCategory(receipt) &&
            matchesSubcategory(receipt) &&
            matchesSearchText(receipt)
        }
    }

    var hasActiveFilter: Bool {
        // 필터나 검색어가 있으면 전체 빈 상태가 아니라 검색/필터 결과 없음 상태로 처리합니다.
        selectedCategory != .all ||
        selectedSubcategory != nil ||
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func setReceipts(_ receipts: [ArchiveReceipt]) {
        self.receipts = receipts
    }

    func selectCategory(_ category: ArchiveCategory) {
        selectedCategory = category
        selectedSubcategory = nil
    }

    func selectSubcategory(_ subcategory: ArchiveSubcategory) {
        selectedSubcategory = subcategory
    }

    func selectAllSubcategories() {
        selectedSubcategory = nil
    }

    func clearSearchText() {
        searchText = ""
    }

    func resetFilters() {
        searchText = ""
        selectedCategory = .all
        selectedSubcategory = nil
    }
}

private extension ArchiveController {
    func matchesCategory(_ receipt: ArchiveReceipt) -> Bool {
        selectedCategory == .all || receipt.category == selectedCategory
    }

    func matchesSubcategory(_ receipt: ArchiveReceipt) -> Bool {
        guard let selectedSubcategory else {
            return true
        }

        return receipt.subcategory == selectedSubcategory
    }

    func matchesSearchText(_ receipt: ArchiveReceipt) -> Bool {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !keyword.isEmpty else {
            return true
        }

        return receipt.searchKeywords.contains {
            $0.localizedCaseInsensitiveContains(keyword)
        }
    }
}
