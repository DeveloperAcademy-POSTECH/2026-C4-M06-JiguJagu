//
//  SearchLoadingFlowView.swift
//  JiguJagu
//
//  Created by Codex on 7/22/26.
//

import SwiftUI

struct SearchLoadingFlowView: View {
    @State private var controller: SearchLoadingController

    init(analysis: ClothingAnalysis) {
        _controller = State(initialValue: SearchLoadingController(analysis: analysis))
    }

    var body: some View {
        Group {
            if controller.isReady {
                ProductSearchResultView(
                    analysis: controller.analysis,
                    items: controller.items,
                    searchErrorMessage: controller.errorMessage,
                    shouldSearchInitialQuery: false
                )
            } else {
                LoadingView(
                    controller: LoadingController(configuration: .clothingSearch),
                    progress: controller.progress
                )
            }
        }
        .task {
            await controller.loadSearchResults()
        }
    }
}
