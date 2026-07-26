//
//  ArchiveView.swift
//  JiguJagu
//
//

import SwiftUI
import SwiftData

private enum ArchiveCarouselLayout {
    nonisolated static let cardTopPadding: CGFloat = 40
    nonisolated static let cardSpacing: CGFloat = 30
    nonisolated static let sideCardWidthScale: CGFloat = 0.9
    nonisolated static let sideCardHeightScale: CGFloat = 0.82
    nonisolated static let sideCardOpacity: CGFloat = 0.78
    nonisolated static let sideCardYOffset: CGFloat = 28
    nonisolated static let swipeThreshold: CGFloat = 70
    nonisolated static let flickThreshold: CGFloat = 110
    nonisolated static let dragMinimumDistance: CGFloat = 12
    nonisolated static let animation = Animation.spring(response: 0.34, dampingFraction: 0.82)
    nonisolated static let commitAnimationDuration: UInt64 = 340_000_000
}

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var controller: ArchiveController
    @State private var focusedReceiptIndex = 0
    @State private var focusedReceiptID: String?
    @State private var carouselSettledOffset: CGFloat = 0
    @State private var isCommittingCarouselMove = false
    @State private var selectedReceipt: ArchiveReceipt?
    @GestureState private var carouselDragTranslation: CGFloat = 0
    private let receiptStore = SwiftDataReceiptStore()
    private let loadsPersistedReceipts: Bool
    private let onBackButtonTap: () -> Void
    private let onRegisterButtonTap: () -> Void

    init(
        receipts: [ArchiveReceipt]? = nil,
        initialCategory: ArchiveCategory = .all,
        loadsPersistedReceipts: Bool? = nil,
        onBackButtonTap: @escaping () -> Void = {},
        onRegisterButtonTap: @escaping () -> Void = {}
    ) {
        _controller = State(
            initialValue: ArchiveController(
                receipts: receipts ?? [],
                initialCategory: initialCategory
            )
        )
        self.loadsPersistedReceipts = loadsPersistedReceipts ?? (receipts == nil)
        self.onBackButtonTap = onBackButtonTap
        self.onRegisterButtonTap = onRegisterButtonTap
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
        .navigationDestination(isPresented: isShowingReceiptDetail) {
            receiptDetailView
        }
        .task {
            loadPersistedReceiptsIfNeeded()
        }
    }
}

private extension ArchiveView {
    func loadPersistedReceiptsIfNeeded() {
        guard loadsPersistedReceipts else {
            return
        }

        controller.loadReceipts(
            from: receiptStore,
            context: modelContext
        )
    }

    func emptyStatePrimaryAction() {
        if controller.receiptLoadErrorMessage != nil {
            loadPersistedReceiptsIfNeeded()
        } else if shouldShowRegisterEmptyState {
            onRegisterButtonTap()
        } else {
            controller.resetFilters()
        }
    }

    var emptyStateStyle: ArchiveEmptyStateStyle {
        if let receiptLoadErrorMessage = controller.receiptLoadErrorMessage {
            return .loadFailed(message: receiptLoadErrorMessage)
        }

        if controller.filteredReceipts.isEmpty {
            // 필터 없음 + 전체 데이터 없음
            if controller.selectedCategory == .all &&
               controller.selectedSubcategory == nil &&
               controller.searchText.isEmpty {
                return .noReceipts
            }

            // 소분류 선택
            if let subcategory = controller.selectedSubcategory {
                return .noCategoryReceipts(category: subcategory.title)
            }

            // 대분류 선택
            if controller.selectedCategory != .all {
                return .noCategoryReceipts(category: controller.selectedCategory.displayName)
            }

            return .noResults
        }

        return .noResults
    }

    var shouldShowRegisterEmptyState: Bool {
        switch emptyStateStyle {
        case .noReceipts, .noCategoryReceipts:
            return true
        case .noResults, .loadFailed:
            return false
        }
    }

    var isShowingReceiptDetail: Binding<Bool> {
        Binding(
            get: { selectedReceipt != nil },
            set: { isPresented in
                if !isPresented {
                    selectedReceipt = nil
                }
            }
        )
    }

    @ViewBuilder
    var receiptDetailView: some View {
        if let selectedReceipt {
            ReceiptView(
                clothing: Clothing(from: selectedReceipt),
                localImage: selectedReceipt.localImage,
                registeredDate: selectedReceipt.registeredDate,
                displayMode: .archived,
                onClose: { self.selectedReceipt = nil }
            )
        }
    }

    var receiptArchiveContent: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if controller.filteredReceipts.isEmpty {
                    ArchiveEmptyStateView(
                        style: emptyStateStyle,
                        onResetButtonTap: emptyStatePrimaryAction
                    )
                    .padding(.top, emptyReceiptTopPadding(availableHeight: geometry.size.height))
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
        HStack(alignment: .top, spacing: ArchiveCarouselLayout.cardSpacing) {
            ForEach(carouselDisplayItems) { item in
                receiptCardItem(item)
                    .id(item.id)
                    .scaleEffect(
                        x: carouselWidthScale(for: item),
                        y: carouselHeightScale(for: item)
                    )
                    .opacity(carouselOpacity(for: item))
                    .offset(y: carouselYOffset(for: item))
            }
        }
        .frame(width: carouselContentWidth)
        .offset(x: carouselBaseOffset(screenWidth: screenWidth) + carouselVisualOffset)
        .frame(width: screenWidth, alignment: .leading)
        .contentShape(Rectangle())
        .animation(.interactiveSpring(response: 0.24, dampingFraction: 0.86), value: carouselDragTranslation)
        .highPriorityGesture(carouselDragGesture)
        .clipped()
        .accessibilityElement(children: .contain)
        .accessibilityAdjustableAction { direction in
            moveFocusedReceipt(
                direction: direction == .increment ? .next : .previous
            )
        }
        .onAppear {
            syncFocusedReceiptIndexWithCurrentReceipts()
        }
        .onChange(of: carouselReceiptIDs) { _, _ in
            syncFocusedReceiptIndexWithCurrentReceipts()
        }
    }

    func emptyReceiptTopPadding(availableHeight: CGFloat) -> CGFloat {
        let preferredTopPadding: CGFloat = 49
        let minimumBottomPadding: CGFloat = 30
        let receiptHeight = ArchiveReceiptCardLayout.bodyHeight + ArchiveReceiptCardLayout.edgeHeight * 2
        let maximumTopPadding = availableHeight - receiptHeight - minimumBottomPadding

        return min(preferredTopPadding, max(0, maximumTopPadding))
    }

    func receiptCardItem(_ item: ArchiveCarouselDisplayItem) -> some View {
        Button {
            if item.position == .current {
                selectedReceipt = item.receipt
            } else {
                moveFocusedReceipt(direction: item.position.carouselDirection)
            }
        } label: {
            ArchiveReceiptCard(receipt: item.receipt)
        }
        .buttonStyle(.plain)
        .accessibilityHidden(item.position != .current)
        .accessibilityLabel(receiptCardAccessibilityLabel(for: item.receipt))
        .accessibilityHint("영수증 상세를 엽니다.")
        .padding(.top, ArchiveCarouselLayout.cardTopPadding)
    }

    func receiptCardAccessibilityLabel(for receipt: ArchiveReceipt) -> String {
        "\(receipt.productName.replacingOccurrences(of: "\n", with: " ")), \(receipt.category.title), \(receipt.dDayText())"
    }

    var carouselReceiptIDs: [String] {
        carouselState.receiptIDs
    }

    var carouselState: ArchiveCarouselState {
        ArchiveCarouselState(receipts: controller.filteredReceipts)
    }

    var carouselDisplayItems: [ArchiveCarouselDisplayItem] {
        carouselState.displayItems(focusedIndex: focusedReceiptIndex)
    }

    var carouselContentWidth: CGFloat {
        ArchiveReceiptCardLayout.width * CGFloat(carouselDisplayItems.count) +
        ArchiveCarouselLayout.cardSpacing * CGFloat(max(carouselDisplayItems.count - 1, 0))
    }

    var carouselPageWidth: CGFloat {
        ArchiveReceiptCardLayout.width + ArchiveCarouselLayout.cardSpacing
    }

    var carouselVisualOffset: CGFloat {
        carouselSettledOffset + carouselDragTranslation
    }

    var carouselDragGesture: some Gesture {
        DragGesture(minimumDistance: ArchiveCarouselLayout.dragMinimumDistance)
            .updating($carouselDragTranslation) { value, state, _ in
                guard carouselState.receipts.count > 1,
                      !isCommittingCarouselMove else {
                    return
                }

                state = value.translation.width
            }
            .onEnded { value in
                moveFocusedReceiptIfNeeded(
                    translationWidth: value.translation.width,
                    predictedTranslationWidth: value.predictedEndTranslation.width
                )
            }
    }

    func carouselBaseOffset(screenWidth: CGFloat) -> CGFloat {
        let centeredCardOffset = (screenWidth - ArchiveReceiptCardLayout.width) / 2

        guard carouselDisplayItems.count > 1 else {
            return centeredCardOffset
        }

        return centeredCardOffset - carouselPageWidth
    }

    func carouselCenterProgress(for item: ArchiveCarouselDisplayItem) -> CGFloat {
        let distanceFromCenter = abs(item.position.slotOffset(pageWidth: carouselPageWidth) + carouselVisualOffset)
        return min(distanceFromCenter / carouselPageWidth, 1)
    }

    func carouselWidthScale(for item: ArchiveCarouselDisplayItem) -> CGFloat {
        interpolate(
            from: 1.0,
            to: ArchiveCarouselLayout.sideCardWidthScale,
            progress: carouselCenterProgress(for: item)
        )
    }

    func carouselHeightScale(for item: ArchiveCarouselDisplayItem) -> CGFloat {
        interpolate(
            from: 1.0,
            to: ArchiveCarouselLayout.sideCardHeightScale,
            progress: carouselCenterProgress(for: item)
        )
    }

    func carouselOpacity(for item: ArchiveCarouselDisplayItem) -> CGFloat {
        interpolate(
            from: 1.0,
            to: ArchiveCarouselLayout.sideCardOpacity,
            progress: carouselCenterProgress(for: item)
        )
    }

    func carouselYOffset(for item: ArchiveCarouselDisplayItem) -> CGFloat {
        interpolate(
            from: 0,
            to: ArchiveCarouselLayout.sideCardYOffset,
            progress: carouselCenterProgress(for: item)
        )
    }

    func interpolate(
        from startValue: CGFloat,
        to endValue: CGFloat,
        progress: CGFloat
    ) -> CGFloat {
        startValue + (endValue - startValue) * progress
    }

    func moveFocusedReceiptIfNeeded(
        translationWidth: CGFloat,
        predictedTranslationWidth: CGFloat
    ) {
        guard carouselState.receipts.count > 1,
              !isCommittingCarouselMove else {
            return
        }

        if shouldCommitLeftSwipe(
            translationWidth: translationWidth,
            predictedTranslationWidth: predictedTranslationWidth
        ) {
            moveFocusedReceipt(
                direction: .next,
                releaseOffset: translationWidth
            )
        } else if shouldCommitRightSwipe(
            translationWidth: translationWidth,
            predictedTranslationWidth: predictedTranslationWidth
        ) {
            moveFocusedReceipt(
                direction: .previous,
                releaseOffset: translationWidth
            )
        }
    }

    func moveFocusedReceipt(
        direction: ArchiveCarouselMoveDirection,
        releaseOffset: CGFloat = 0
    ) {
        guard carouselState.receipts.count > 1,
              !isCommittingCarouselMove else {
            return
        }

        isCommittingCarouselMove = true

        withTransaction(Transaction(animation: nil)) {
            carouselSettledOffset = releaseOffset
        }

        withAnimation(ArchiveCarouselLayout.animation) {
            carouselSettledOffset = direction.settledOffset(pageWidth: carouselPageWidth)
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: ArchiveCarouselLayout.commitAnimationDuration)
            commitFocusedReceiptMove(direction: direction)
        }
    }

    func commitFocusedReceiptMove(direction: ArchiveCarouselMoveDirection) {
        guard !carouselState.receipts.isEmpty else {
            carouselSettledOffset = 0
            isCommittingCarouselMove = false
            return
        }

        switch direction {
        case .previous:
            focusedReceiptIndex = carouselState.previousIndex(from: focusedReceiptIndex)
        case .next:
            focusedReceiptIndex = carouselState.nextIndex(from: focusedReceiptIndex)
        }

        focusedReceiptID = carouselState.receipts[focusedReceiptIndex].id

        withTransaction(Transaction(animation: nil)) {
            carouselSettledOffset = 0
        }

        isCommittingCarouselMove = false
    }

    func shouldCommitLeftSwipe(
        translationWidth: CGFloat,
        predictedTranslationWidth: CGFloat
    ) -> Bool {
        translationWidth <= -ArchiveCarouselLayout.swipeThreshold ||
        predictedTranslationWidth <= -ArchiveCarouselLayout.flickThreshold
    }

    func shouldCommitRightSwipe(
        translationWidth: CGFloat,
        predictedTranslationWidth: CGFloat
    ) -> Bool {
        translationWidth >= ArchiveCarouselLayout.swipeThreshold ||
        predictedTranslationWidth >= ArchiveCarouselLayout.flickThreshold
    }

    func syncFocusedReceiptIndexWithCurrentReceipts() {
        guard let focusedReceiptID,
              let focusedIndex = carouselState.index(for: focusedReceiptID) else {
            focusedReceiptIndex = 0
            self.focusedReceiptID = carouselState.receipts.first?.id
            return
        }

        focusedReceiptIndex = focusedIndex
        self.focusedReceiptID = carouselState.receipts[focusedIndex].id
    }
}

private enum ArchiveCarouselMoveDirection {
    case previous
    case next

    func settledOffset(pageWidth: CGFloat) -> CGFloat {
        switch self {
        case .previous:
            return pageWidth
        case .next:
            return -pageWidth
        }
    }
}

private extension ArchiveCarouselDisplayPosition {
    var carouselDirection: ArchiveCarouselMoveDirection {
        switch self {
        case .previous:
            return .previous
        case .current, .next:
            return .next
        }
    }

    func slotOffset(pageWidth: CGFloat) -> CGFloat {
        switch self {
        case .previous:
            return -pageWidth
        case .current:
            return 0
        case .next:
            return pageWidth
        }
    }
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

#Preview {
    ArchiveView()
}
