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

    func moveBack() {
        switch route {
        case .category:
            break
        case .detail:
            route = .category
        case .productName(let draft):
            route = draft.mainCategory.skipsDetailSelection ? .category : .detail(draft.mainCategory)
        }
    }

    func selectMainCategory(_ category: RegisterMainCategory) {
        if category.skipsDetailSelection {
            route = .productName(
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
        route = .productName(
            RegisterDraft(
                mainCategory: selection.mainCategory,
                subcategory: selection.subcategory,
                color: selection.color
            )
        )
    }
}

enum RegisterFlowRoute: Equatable {
    case category
    case detail(RegisterMainCategory)
    case productName(RegisterDraft)
}
