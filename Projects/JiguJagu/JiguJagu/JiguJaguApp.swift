//
//  JiguJaguApp.swift
//  JiguJagu
//
//  Created by SIA on 7/13/26.
//

import SwiftUI
import SwiftData

@main
struct JiguJaguApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(
            for: [
                ArchiveReceiptEntity.self,
                ArchiveMaterialEntity.self,
                ArchiveWashingGuideEntity.self
            ]
        )
    }
}
