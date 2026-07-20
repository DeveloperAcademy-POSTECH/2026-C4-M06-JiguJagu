//
//  RegisterFlowView.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterFlowView: View {
    @StateObject private var controller = RegisterFlowController()

    var body: some View {
        Group {
            switch controller.route {
            case .category:
                RegisterCategoryView(
                    onBack: {},
                    onNext: controller.selectMainCategory
                )
            case .detail(let category):
                RegisterDetailSelectionView(
                    category: category,
                    onBack: controller.moveBack,
                    onNext: controller.completeDetailSelection
                )
            case .productName(let draft):
                RegisterProductNamePlaceholderView(
                    draft: draft,
                    onBack: controller.moveBack
                )
            }
        }
    }
}

#Preview {
    RegisterFlowView()
}
