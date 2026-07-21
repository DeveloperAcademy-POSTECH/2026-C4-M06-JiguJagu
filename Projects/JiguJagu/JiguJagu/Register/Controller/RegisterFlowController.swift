//
//  RegisterFlowController.swift
//  JiguJagu
//
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
        // 기타 카테고리는 상세 선택 없이 제품 정보 입력으로 이동합니다.
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
