//
//  LoadingProgressState.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import Foundation

struct LoadingProgressState: Equatable {
    var progress: Double
    let message: String
    let accessibilityProgressLabel: String

    init(
        progress: Double = 0.2,
        message: String = "비슷한 의류를 찾고 있어요...",
        accessibilityProgressLabel: String = "의류 탐색 진행률"
    ) {
        self.progress = progress
        self.message = message
        self.accessibilityProgressLabel = accessibilityProgressLabel
    }

    var accessibilityProgressValue: String {
        let percent = Int((progress * 100).rounded())

        return "\(percent)퍼센트"
    }

    mutating func updateProgress(_ progress: Double) {
        self.progress = min(max(progress, 0), 1)
    }
}
