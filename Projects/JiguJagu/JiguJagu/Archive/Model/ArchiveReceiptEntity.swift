//
//  ArchiveReceiptEntity.swift
//  JiguJagu
//
//

import Foundation
import SwiftData

@Model
final class ArchiveReceiptEntity {
    @Attribute(.unique) var id: String
    var brandName: String
    var productName: String
    var categoryID: String
    var subcategoryID: String
    var productImageName: String
    var productImageURL: String?
    @Attribute(.externalStorage) var localImageData: Data?
    var registeredDate: Date
    var careTips: [String]
    var tagNames: [String]

    @Relationship(deleteRule: .cascade) var materials: [ArchiveMaterialEntity]
    @Relationship(deleteRule: .cascade) var washingGuides: [ArchiveWashingGuideEntity]

    init(
        id: String,
        brandName: String,
        productName: String,
        categoryID: String,
        subcategoryID: String,
        productImageName: String,
        productImageURL: String? = nil,
        localImageData: Data? = nil,
        registeredDate: Date,
        careTips: [String] = [],
        tagNames: [String] = [],
        materials: [ArchiveMaterialEntity] = [],
        washingGuides: [ArchiveWashingGuideEntity] = []
    ) {
        self.id = id
        self.brandName = brandName
        self.productName = productName
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.productImageName = productImageName
        self.productImageURL = productImageURL
        self.localImageData = localImageData
        self.registeredDate = registeredDate
        self.careTips = careTips
        self.tagNames = tagNames
        self.materials = materials
        self.washingGuides = washingGuides
    }
}
