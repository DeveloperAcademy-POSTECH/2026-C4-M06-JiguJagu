//
//  SwiftDataReceiptStore.swift
//  JiguJagu
//
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataReceiptStore {
    func save(
        _ receipt: ArchiveReceipt,
        in context: ModelContext
    ) throws {
        if let existingEntity = try fetchEntity(id: receipt.id, in: context) {
            update(existingEntity, with: receipt, in: context)
        } else {
            context.insert(ArchiveReceiptMapper.makeEntity(from: receipt))
        }

        try context.save()
    }

    func loadReceipts(from context: ModelContext) throws -> [ArchiveReceipt] {
        let descriptor = FetchDescriptor<ArchiveReceiptEntity>(
            sortBy: [
                SortDescriptor(\.registeredDate, order: .reverse)
            ]
        )

        return try context.fetch(descriptor).map(ArchiveReceiptMapper.makeReceipt)
    }

    func loadReceipt(
        id: String,
        from context: ModelContext
    ) throws -> ArchiveReceipt? {
        try fetchEntity(id: id, in: context).map(ArchiveReceiptMapper.makeReceipt)
    }

    func update(
        _ receipt: ArchiveReceipt,
        in context: ModelContext
    ) throws {
        if let existingEntity = try fetchEntity(id: receipt.id, in: context) {
            update(existingEntity, with: receipt, in: context)
            try context.save()
        }
    }

    func delete(
        _ receipt: ArchiveReceipt,
        in context: ModelContext
    ) throws {
        try deleteReceipt(id: receipt.id, in: context)
    }

    func deleteReceipt(
        id: String,
        in context: ModelContext
    ) throws {
        guard let entity = try fetchEntity(id: id, in: context) else {
            return
        }

        context.delete(entity)
        try context.save()
    }

    func findDuplicate(
        of receipt: ArchiveReceipt,
        in context: ModelContext
    ) throws -> ArchiveReceipt? {
        let duplicateKey = makeDuplicateKey(for: receipt)

        return try loadReceipts(from: context).first { storedReceipt in
            storedReceipt.id != receipt.id &&
            makeDuplicateKey(for: storedReceipt) == duplicateKey
        }
    }
}

private extension SwiftDataReceiptStore {
    func fetchEntity(
        id: String,
        in context: ModelContext
    ) throws -> ArchiveReceiptEntity? {
        var descriptor = FetchDescriptor<ArchiveReceiptEntity>(
            predicate: #Predicate { entity in
                entity.id == id
            }
        )
        descriptor.fetchLimit = 1

        return try context.fetch(descriptor).first
    }

    func update(
        _ entity: ArchiveReceiptEntity,
        with receipt: ArchiveReceipt,
        in context: ModelContext
    ) {
        let updatedEntity = ArchiveReceiptMapper.makeEntity(from: receipt)

        entity.brandName = updatedEntity.brandName
        entity.productName = updatedEntity.productName
        entity.categoryID = updatedEntity.categoryID
        entity.subcategoryID = updatedEntity.subcategoryID
        entity.productImageName = updatedEntity.productImageName
        entity.productImageURL = updatedEntity.productImageURL
        entity.localImageData = updatedEntity.localImageData
        entity.registeredDate = updatedEntity.registeredDate
        entity.careTips = updatedEntity.careTips
        entity.tagNames = updatedEntity.tagNames

        entity.materials.forEach { context.delete($0) }
        entity.washingGuides.forEach { context.delete($0) }
        entity.materials = updatedEntity.materials
        entity.washingGuides = updatedEntity.washingGuides
    }

    func makeDuplicateKey(for receipt: ArchiveReceipt) -> String {
        [
            receipt.brandName,
            receipt.productName,
            receipt.category.id,
            receipt.subcategory.id
        ]
        .map(normalized)
        .joined(separator: "|")
    }

    func normalized(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
