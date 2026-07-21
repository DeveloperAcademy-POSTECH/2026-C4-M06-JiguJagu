//
//  LoadingProgressConfiguration.swift
//  JiguJagu
//
//  Created by mason on 7/22/26.
//

import Foundation

struct LoadingProgressConfiguration: Equatable {
    let initialProgress: Double
    let resetProgress: Double
    let maximumLoopProgress: Double
    let progressIncrement: Double
    let tickMilliseconds: Int
    let message: String
    let accessibilityProgressLabel: String

    static let clothingSearch = LoadingProgressConfiguration(
        initialProgress: 0.2,
        resetProgress: 0.16,
        maximumLoopProgress: 0.96,
        progressIncrement: 0.006,
        tickMilliseconds: 45,
        message: "비슷한 의류를 찾고 있어요...",
        accessibilityProgressLabel: "의류 탐색 진행률"
    )

    static let receiptIssuing = LoadingProgressConfiguration(
        initialProgress: 0.2,
        resetProgress: 0.16,
        maximumLoopProgress: 0.96,
        progressIncrement: 0.006,
        tickMilliseconds: 45,
        message: "영수증을 발급하고있어요...",
        accessibilityProgressLabel: "영수증 발급 진행률"
    )
}
