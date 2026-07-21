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
    private(set) var progressState = LoadingProgressState()
    @ObservationIgnored private var progressTask: Task<Void, Never>?

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
            progress += 0.012

            if progress > 0.92 {
                progress = 0.16
            }

            await MainActor.run {
                progressState.progress = progress
            }

            try? await Task.sleep(for: .milliseconds(45))
        }
    }
}
