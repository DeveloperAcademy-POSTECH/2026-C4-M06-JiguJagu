//
//  LoadingProgressState.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import Foundation

struct LoadingProgressState: Equatable {
    var progress: Double = 0.2
    var message: String = "비슷한 의류를 찾고 있어요..."

    var accessibilityProgressText: String {
        let percent = Int((progress * 100).rounded())

        return "진행률 \(percent)퍼센트"
    }
}
