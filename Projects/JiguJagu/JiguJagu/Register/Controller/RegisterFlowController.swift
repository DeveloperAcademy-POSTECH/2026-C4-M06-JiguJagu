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
    @Published private(set) var completedDraft: RegisterDraft?
    
    func moveBack() {
        switch route {
        case .category:
            break
            
        case .detail:
            route = .category
            
        case .productInfo(let draft):
            route = draft.mainCategory.skipsDetailSelection
            ? .category
            : .detail(draft.mainCategory)
            
        case .confirm:
            if let draft = completedDraft {
                route = .productInfo(draft)
            }
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
    
    func completeDetailSelection(_ draft: RegisterDraft) {
        route = .productInfo(draft)
    }
    
    func completeProductInput(_ inputState: RegisterProductInputState) {
        guard inputState.hasProductName else { return }
        
        completedProductInput = inputState
        
        guard case .productInfo(let draft) = route else {
            return
        }
        
        completedDraft = draft
        
        route = .confirm(
            Clothing(
                brand: inputState.brandName,
                productName: inputState.productName,
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

enum RegisterFlowRoute {
    case category
    case detail(RegisterMainCategory)
    case productInfo(RegisterDraft)
    case confirm(Clothing)
}
