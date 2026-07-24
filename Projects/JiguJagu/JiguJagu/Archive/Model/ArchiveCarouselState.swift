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

    func displayItems(focusedIndex: Int) -> [ArchiveCarouselDisplayItem] {
        guard !receipts.isEmpty else {
            return []
        }

        guard receipts.count > 1 else {
            return [
                ArchiveCarouselDisplayItem(
                    id: makeDisplayItemID(position: .current, receiptIndex: 0),
                    receipt: receipts[0],
                    receiptIndex: 0,
                    position: .current
                )
            ]
        }

        let currentIndex = normalizedIndex(focusedIndex)
        let previousIndex = previousIndex(from: currentIndex)
        let nextIndex = nextIndex(from: currentIndex)

        return [
            makeDisplayItem(position: .previous, receiptIndex: previousIndex),
            makeDisplayItem(position: .current, receiptIndex: currentIndex),
            makeDisplayItem(position: .next, receiptIndex: nextIndex)
        ]
    }

    func normalizedIndex(_ index: Int) -> Int {
        guard !receipts.isEmpty else {
            return 0
        }

        return (index % receipts.count + receipts.count) % receipts.count
    }

    func previousIndex(from index: Int) -> Int {
        normalizedIndex(index - 1)
    }

    func nextIndex(from index: Int) -> Int {
        normalizedIndex(index + 1)
    }

    func index(for receiptID: String) -> Int? {
        receipts.firstIndex { $0.id == receiptID }
    }
}

private extension ArchiveCarouselState {
    func makeDisplayItem(
        position: ArchiveCarouselDisplayPosition,
        receiptIndex: Int
    ) -> ArchiveCarouselDisplayItem {
        ArchiveCarouselDisplayItem(
            id: makeDisplayItemID(position: position, receiptIndex: receiptIndex),
            receipt: receipts[receiptIndex],
            receiptIndex: receiptIndex,
            position: position
        )
    }

    func makeDisplayItemID(
        position: ArchiveCarouselDisplayPosition,
        receiptIndex: Int
    ) -> String {
        "\(position.rawValue)-\(receiptIndex)-\(receipts[receiptIndex].id)"
    }
}

struct ArchiveCarouselDisplayItem: Identifiable {
    let id: String
    let receipt: ArchiveReceipt
    let receiptIndex: Int
    let position: ArchiveCarouselDisplayPosition
}

enum ArchiveCarouselDisplayPosition: String {
    case previous
    case current
    case next
}
