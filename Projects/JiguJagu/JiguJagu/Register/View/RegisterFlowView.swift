//
//  RegisterFlowView.swift
//  JiguJagu
//
//

import SwiftUI

struct RegisterFlowView: View {
    @StateObject private var controller = RegisterFlowController()
    
    var body: some View {
        NavigationStack {
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
                        onNext: { _, inputState in
                            controller.completeProductInput(inputState)
                        }
                    )
                }
            }
            .navigationDestination(
                isPresented: $controller.showConfirm
            ) {
                if let draft = controller.completedDraft,
                   let input = controller.completedProductInput {

                    RegisterConfirmView(
                        clothing: Clothing(
                            brand: input.brandName,
                            productName: input.productName,
                            mockImageName: nil,
                            productImageURL: nil,
                            receiptCategory: "\(draft.mainCategory.displayName) > \(draft.subcategory?.title ?? "그 외")",
                            category3: draft.mainCategory.displayName,
                            category4: draft.subcategory?.title ?? "그 외",
                            howToCare: [],
                            washingGuides: [],
                            materials: [],
                            color: draft.color?.title ?? "유색"
                        )
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    RegisterFlowView()
}
