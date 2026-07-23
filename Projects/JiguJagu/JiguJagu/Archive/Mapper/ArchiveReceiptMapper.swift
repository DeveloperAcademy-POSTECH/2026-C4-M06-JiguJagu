//
//  ArchiveReceiptMapper.swift
//  JiguJagu
//
//

import UIKit

@MainActor
enum ArchiveReceiptMapper {
    static func makeEntity(from receipt: ArchiveReceipt) -> ArchiveReceiptEntity {
        ArchiveReceiptEntity(
            id: receipt.id,
            brandName: receipt.brandName,
            productName: receipt.productName,
            categoryID: receipt.category.id,
            subcategoryID: receipt.subcategory.id,
            productImageName: receipt.productImageName,
            productImageURL: receipt.productImageURL,
            localImageData: receipt.localImage?.pngData(),
            registeredDate: receipt.registeredDate,
            careTips: receipt.careTips,
            tagNames: receipt.tagNames,
            materials: receipt.materials.map(makeEntity),
            washingGuides: receipt.washingGuides.map(makeEntity)
        )
    }

    static func makeReceipt(from entity: ArchiveReceiptEntity) -> ArchiveReceipt {
        let category = makeCategory(from: entity.categoryID)

        return ArchiveReceipt(
            id: entity.id,
            brandName: entity.brandName,
            productName: entity.productName,
            category: category,
            subcategory: makeSubcategory(
                from: entity.subcategoryID,
                category: category
            ),
            productImageName: entity.productImageName,
            productImageURL: entity.productImageURL,
            localImage: entity.localImageData.flatMap(UIImage.init(data:)),
            registeredDate: entity.registeredDate,
            materials: entity.materials.map(makeMaterial),
            careTips: entity.careTips,
            washingGuides: entity.washingGuides.map(makeWashingGuide),
            tagNames: entity.tagNames
        )
    }
}

private extension ArchiveReceiptMapper {
    static func makeEntity(from material: Material) -> ArchiveMaterialEntity {
        ArchiveMaterialEntity(
            name: material.name,
            percentage: material.percentage
        )
    }

    static func makeEntity(from washingGuide: WashingGuide) -> ArchiveWashingGuideEntity {
        ArchiveWashingGuideEntity(
            id: washingGuide.id,
            washingIcon: washingGuide.washingIcon,
            washingDescription: washingGuide.washingDescription
        )
    }

    static func makeMaterial(from entity: ArchiveMaterialEntity) -> Material {
        Material(
            name: entity.name,
            percentage: entity.percentage
        )
    }

    static func makeWashingGuide(from entity: ArchiveWashingGuideEntity) -> WashingGuide {
        WashingGuide(
            id: entity.id,
            washingIcon: entity.washingIcon,
            washingDescription: entity.washingDescription
        )
    }

    static func makeCategory(from id: String) -> ArchiveCategory {
        ArchiveCategory(rawValue: id) ?? .tops
    }

    static func makeSubcategory(
        from id: String,
        category: ArchiveCategory
    ) -> ArchiveSubcategory {
        if let subcategory = category.subcategories.first(where: { $0.id == id }) {
            return normalized(subcategory, category: category)
        }

        if let subcategory = ArchiveSubcategory.all.first(where: { $0.id == id }) {
            return normalized(subcategory, category: category)
        }

        return category.subcategories.first ?? ArchiveSubcategory(
            id: id,
            title: "그 외",
            category: category
        )
    }

    static func normalized(
        _ subcategory: ArchiveSubcategory,
        category: ArchiveCategory
    ) -> ArchiveSubcategory {
        guard subcategory.category != category else {
            return subcategory
        }

        return ArchiveSubcategory(
            id: subcategory.id,
            title: subcategory.title,
            category: category
        )
    }
}
