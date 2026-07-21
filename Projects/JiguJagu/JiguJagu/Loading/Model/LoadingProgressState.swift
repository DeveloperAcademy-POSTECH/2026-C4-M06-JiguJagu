//
//  LoadingProgressState.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import Foundation

struct LoadingProgressState: Equatable {
    var progress: Double = 0.2
    let message: String = "비슷한 의류를 찾고 있어요..."

    var accessibilityProgressValue: String {
        let percent = Int((progress * 100).rounded())

        return "\(percent)퍼센트"
    }

    mutating func updateProgress(_ progress: Double) {
        self.progress = min(max(progress, 0), 1)
    }
}
