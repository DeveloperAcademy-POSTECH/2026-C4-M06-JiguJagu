//
//  RegisterFlowView.swift
//  JiguJagu
//
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
            case .productInfo(let draft):
                RegisterProductInfoView(
                    draft: draft,
                    onBack: controller.moveBack,
                    onNext: controller.completeProductInput
                )
            }
        }
    }
}

#Preview {
    RegisterFlowView()
}
