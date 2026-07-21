//
//  LoadingController.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import Foundation
import Observation

@Observable
final class LoadingController {
    private(set) var progressState: LoadingProgressState
    private let configuration: LoadingProgressConfiguration
    @ObservationIgnored private var progressTask: Task<Void, Never>?

    init(configuration: LoadingProgressConfiguration = .clothingSearch) {
        self.configuration = configuration
        self.progressState = LoadingProgressState(
            progress: configuration.initialProgress,
            message: configuration.message,
            accessibilityProgressLabel: configuration.accessibilityProgressLabel
        )
    }

    deinit {
        progressTask?.cancel()
    }

    func startProgressLoop() {
        guard progressTask == nil else {
            return
        }

        progressTask = Task { [weak self] in
            await self?.runProgressLoop()
        }
    }

    func stopProgressLoop() {
        progressTask?.cancel()
        progressTask = nil
    }
}

private extension LoadingController {
    func runProgressLoop() async {
        var progress = progressState.progress

        while !Task.isCancelled {
            progress += configuration.progressIncrement

            if progress > configuration.maximumLoopProgress {
                progress = configuration.resetProgress
            }

            await MainActor.run {
                progressState.updateProgress(progress)
            }

            try? await Task.sleep(for: .milliseconds(configuration.tickMilliseconds))
        }
    }
}
