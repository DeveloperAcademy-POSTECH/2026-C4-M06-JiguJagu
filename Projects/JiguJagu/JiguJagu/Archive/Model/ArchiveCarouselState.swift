//
//  ArchiveCarouselState.swift
//  JiguJagu
//
//

import Foundation

struct ArchiveCarouselState {
    let receipts: [ArchiveReceipt]

    init(receipts: [ArchiveReceipt]) {
        self.receipts = receipts.sorted { lhs, rhs in
            lhs.registeredDate > rhs.registeredDate
        }
    }

    var receiptIDs: [String] {
        receipts.map(\.id)
    }

    var displayItems: [ArchiveCarouselDisplayItem] {
        if receipts.count == 2 {
            return [
                ArchiveCarouselDisplayItem(id: "left-\(receipts[1].id)", receipt: receipts[1]),
                ArchiveCarouselDisplayItem(id: "center-\(receipts[0].id)", receipt: receipts[0]),
                ArchiveCarouselDisplayItem(id: "right-\(receipts[1].id)", receipt: receipts[1])
            ]
        }

        if receipts.count >= 3 {
            let oldestReceipt = receipts[receipts.count - 1]
            let centerAndRightReceipts = receipts.dropLast()
            let orderedReceipts = [oldestReceipt] + centerAndRightReceipts

            return orderedReceipts.enumerated().map { index, receipt in
                ArchiveCarouselDisplayItem(id: "\(index)-\(receipt.id)", receipt: receipt)
            }
        }

        return receipts.map { receipt in
            ArchiveCarouselDisplayItem(id: receipt.id, receipt: receipt)
        }
    }

    var initialFocusedItemID: String? {
        guard let newestReceipt = receipts.first else {
            return nil
        }

        if receipts.count == 2 {
            return "center-\(newestReceipt.id)"
        }

        return displayItems.first {
            $0.receipt.id == newestReceipt.id
        }?.id
    }
}

struct ArchiveCarouselDisplayItem: Identifiable {
    let id: String
    let receipt: ArchiveReceipt
}
