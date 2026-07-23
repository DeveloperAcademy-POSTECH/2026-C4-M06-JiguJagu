//
//  ArchiveWashingGuideEntity.swift
//  JiguJagu
//
//

import SwiftData

@Model
final class ArchiveWashingGuideEntity {
    var id: String
    var washingIcon: String
    var washingDescription: String

    init(
        id: String,
        washingIcon: String,
        washingDescription: String
    ) {
        self.id = id
        self.washingIcon = washingIcon
        self.washingDescription = washingDescription
    }
}
