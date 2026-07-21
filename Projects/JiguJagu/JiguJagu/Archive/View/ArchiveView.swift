//
//  ArchiveView.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct ArchiveView: View {
    @State private var controller: ArchiveController
    private let onBackButtonTap: () -> Void

    init(
        receipts: [ArchiveReceipt] = ArchiveReceipt.previewItems,
        onBackButtonTap: @escaping () -> Void = {}
    ) {
        _controller = State(initialValue: ArchiveController(receipts: receipts))
        self.onBackButtonTap = onBackButtonTap
    }

    var body: some View {
        @Bindable var controller = controller

        VStack(spacing: 0) {
            ArchiveHeaderView(
                searchText: $controller.searchText,
                onBackButtonTap: onBackButtonTap
            )

            ArchiveCategoryFilterView(
                categories: controller.categories,
                selectedCategory: controller.selectedCategory,
                subcategories: controller.availableSubcategories,
                selectedSubcategory: controller.selectedSubcategory,
                onCategoryTap: { controller.selectCategory($0) },
                onAllSubcategoryTap: { controller.selectAllSubcategories() },
                onSubcategoryTap: { controller.selectSubcategory($0) }
            )
            .zIndex(1)

            receiptArchiveContent
                .zIndex(0)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

private extension ArchiveView {
    var receiptArchiveContent: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if controller.filteredReceipts.isEmpty {
                    ArchiveEmptyStateView(
                        hasActiveFilter: controller.hasActiveFilter,
                        onResetButtonTap: controller.resetFilters
                    )
                    .padding(.top, 28)
                } else {
                    receiptCards(screenWidth: geometry.size.width)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .background {
                Image("ArchiveBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .opacity(0.8)                
            }
        }
    }

    func receiptCards(screenWidth: CGFloat) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(displayReceiptItems) { item in
                        receiptCardItem(item.receipt)
                            .id(item.id)
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.86)
                                    .opacity(phase.isIdentity ? 1.0 : 0.78)
                                    .offset(y: phase.isIdentity ? 0 : 18)
                            }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, max((screenWidth - 266) / 2, 24))
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollTargetBehavior(.viewAligned)
            .onAppear {
                guard let focusedReceiptID else {
                    return
                }

                proxy.scrollTo(focusedReceiptID, anchor: .center)
            }
            .onChange(of: filteredReceiptIDs) { _, _ in
                guard let focusedReceiptID else {
                    return
                }

                withAnimation(.easeInOut(duration: 0.2)) {
                    proxy.scrollTo(focusedReceiptID, anchor: .center)
                }
            }
        }
    }

    func receiptCardItem(_ receipt: ArchiveReceipt) -> some View {
        VStack(spacing: 8) {
            Text(receipt.keptDaysText())
                .font(.pretendard.head4)
                .foregroundStyle(Color.white)
                .frame(width: 266)
                .padding(.top, 10)

            ArchiveReceiptCard(receipt: receipt)
        }
    }

    var sortedReceipts: [ArchiveReceipt] {
        // 보관함의 기준 카드는 항상 최신 등록 영수증이므로 등록일 내림차순으로 정렬합니다.
        controller.filteredReceipts.sorted { lhs, rhs in
            lhs.registeredDate > rhs.registeredDate
        }
    }

    var sortedReceiptIDs: [String] {
        sortedReceipts.map(\.id)
    }

    var filteredReceiptIDs: [String] {
        controller.filteredReceipts.map(\.id)
    }

    var displayReceiptItems: [ArchiveReceiptDisplayItem] {
        let receipts = sortedReceipts

        if receipts.count == 2 {
            // 카드가 2개일 때는 최신 카드 양쪽에 같은 이전 카드를 배치해 순환 구조를 보여줍니다.
            return [
                ArchiveReceiptDisplayItem(id: "left-\(receipts[1].id)", receipt: receipts[1]),
                ArchiveReceiptDisplayItem(id: "center-\(receipts[0].id)", receipt: receipts[0]),
                ArchiveReceiptDisplayItem(id: "right-\(receipts[1].id)", receipt: receipts[1])
            ]
        }

        if receipts.count >= 3 {
            // 최신 카드가 중앙에 오도록 가장 오래된 카드를 앞에 붙여 왼쪽 미리보기 카드로 사용합니다.
            let oldestReceipt = receipts[receipts.count - 1]
            let centerAndRightReceipts = receipts.dropLast()
            let orderedReceipts = [oldestReceipt] + centerAndRightReceipts

            return orderedReceipts.enumerated().map { index, receipt in
                ArchiveReceiptDisplayItem(id: "\(index)-\(receipt.id)", receipt: receipt)
            }
        }

        return receipts.map { receipt in
            ArchiveReceiptDisplayItem(id: receipt.id, receipt: receipt)
        }
    }

    var focusedReceiptID: String? {
        guard let newestReceipt = sortedReceipts.first else {
            return nil
        }

        // 2개 배치에서는 최신 카드가 중복 id 사이에 있으므로 중앙 전용 id로 초기 포커스를 맞춥니다.
        return sortedReceipts.count == 2 ? "center-\(newestReceipt.id)" : displayReceiptItems.first {
            $0.receipt.id == newestReceipt.id
        }?.id
    }
}

private struct ArchiveReceiptDisplayItem: Identifiable {
    let id: String
    let receipt: ArchiveReceipt
}

#Preview {
    ArchiveView(receipts: ArchiveReceipt.previewItems)
}

#Preview("Two Receipts") {
    ArchiveView(receipts: ArchiveReceipt.previewTwoItems)
}

#Preview("Empty Archive") {
    ArchiveView(receipts: [])
}

private extension ArchiveReceipt {
    static var previewTwoItems: [ArchiveReceipt] {
        Array(previewItems.prefix(2))
    }

    static let previewItems: [ArchiveReceipt] = [
        ArchiveReceipt(
            id: "preview-outers",
            brandName: "모이프",
            productName: "벨벳 싱글\n자켓",
            category: .outers,
            subcategory: ArchiveSubcategory.outers[0],
            productImageName: "MockProduct",
            registeredDate: Calendar.current.date(
                byAdding: .day,
                value: -214,
                to: Date()
            ) ?? Date(),
            materials: [
                Material(name: "Cotton", percentage: 45),
                Material(name: "Polyester", percentage: 35),
                Material(name: "Rayon", percentage: 15),
                Material(name: "Span", percentage: 5)
            ]
        ),
        ArchiveReceipt(
            id: "preview-outers-padding",
            brandName: "파르티멘토",
            productName: "라이트 다운\n패딩",
            category: .outers,
            subcategory: ArchiveSubcategory.outers[2],
            productImageName: "MockProduct",
            registeredDate: Calendar.current.date(
                byAdding: .day,
                value: -168,
                to: Date()
            ) ?? Date(),
            materials: [
                Material(name: "Nylon", percentage: 55),
                Material(name: "Polyester", percentage: 35),
                Material(name: "Duck Down", percentage: 10)
            ]
        ),
        ArchiveReceipt(
            id: "preview-tops",
            brandName: "칙스",
            productName: "더블 스트라이프\n카라 니트",
            category: .tops,
            subcategory: ArchiveSubcategory.tops[0],
            productImageName: "MockProduct",
            registeredDate: Calendar.current.date(
                byAdding: .day,
                value: -137,
                to: Date()
            ) ?? Date(),
            materials: [
                Material(name: "Acrylic", percentage: 60),
                Material(name: "Polyester", percentage: 20),
                Material(name: "Wool", percentage: 15),
                Material(name: "Nylon", percentage: 5)
            ]
        ),
        ArchiveReceipt(
            id: "preview-tops-hoodie",
            brandName: "예일",
            productName: "아치 로고\n후드",
            category: .tops,
            subcategory: ArchiveSubcategory.tops[2],
            productImageName: "MockProduct",
            registeredDate: Calendar.current.date(
                byAdding: .day,
                value: -109,
                to: Date()
            ) ?? Date(),
            materials: [
                Material(name: "Cotton", percentage: 80),
                Material(name: "Polyester", percentage: 20)
            ]
        ),
        ArchiveReceipt(
            id: "preview-bottoms",
            brandName: "어반드레스",
            productName: "와이드 코튼\n카고 팬츠",
            category: .bottoms,
            subcategory: ArchiveSubcategory.bottoms[1],
            productImageName: "MockProduct",
            registeredDate: Calendar.current.date(
                byAdding: .day,
                value: -82,
                to: Date()
            ) ?? Date(),
            materials: [
                Material(name: "Cotton", percentage: 70),
                Material(name: "Polyester", percentage: 25),
                Material(name: "Span", percentage: 5)
            ]
        ),
        ArchiveReceipt(
            id: "preview-bottoms-jeans",
            brandName: "무신사 스탠다드",
            productName: "릴렉스드 데님\n팬츠",
            category: .bottoms,
            subcategory: ArchiveSubcategory.bottoms[0],
            productImageName: "MockProduct",
            registeredDate: Calendar.current.date(
                byAdding: .day,
                value: -46,
                to: Date()
            ) ?? Date(),
            materials: [
                Material(name: "Cotton", percentage: 98),
                Material(name: "Span", percentage: 2)
            ]
        )
    ]
}
