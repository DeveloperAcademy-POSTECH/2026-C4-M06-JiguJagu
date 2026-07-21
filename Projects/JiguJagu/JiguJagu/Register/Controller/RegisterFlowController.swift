//
//  RegisterFlowController.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import Combine
import Foundation

@MainActor
final class RegisterFlowController: ObservableObject {
    @Published private(set) var route: RegisterFlowRoute = .category
    @Published private(set) var completedProductInput: RegisterProductInputState?

    func moveBack() {
        switch route {
        case .category:
            break
        case .detail:
            route = .category
        case .productInfo(let draft):
            route = draft.mainCategory.skipsDetailSelection ? .category : .detail(draft.mainCategory)
        }
    }

    func selectMainCategory(_ category: RegisterMainCategory) {
        if category.skipsDetailSelection {
            route = .productInfo(
                RegisterDraft(
                    mainCategory: category,
                    subcategory: nil,
                    color: nil
                )
            )
            return
        }

        route = .detail(category)
    }

    func completeDetailSelection(_ selection: RegisterDetailSelection) {
        route = .productInfo(
            RegisterDraft(
                mainCategory: selection.mainCategory,
                subcategory: selection.subcategory,
                color: selection.color
            )
        )
    }

    func completeProductInput(_ inputState: RegisterProductInputState) {
        guard inputState.hasProductName else { return }
        completedProductInput = inputState
    }
}

enum RegisterFlowRoute: Equatable {
    case category
    case detail(RegisterMainCategory)
    case productInfo(RegisterDraft)
}
