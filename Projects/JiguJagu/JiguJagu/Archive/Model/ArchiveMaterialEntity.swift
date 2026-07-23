//
//  ArchiveMaterialEntity.swift
//  JiguJagu
//
//

import SwiftData

@Model
final class ArchiveMaterialEntity {
    var name: String
    var percentage: Int

    init(name: String, percentage: Int) {
        self.name = name
        self.percentage = percentage
    }
}
