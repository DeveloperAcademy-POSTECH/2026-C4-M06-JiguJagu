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
    nonisolated static let animation = Animation.spring(response: 0.34, dampingFraction: 0.82)
}

struct ArchiveView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var controller: ArchiveController
    @State private var focusedReceiptIndex = 0
    @State private var focusedReceiptID: String?
    @State private var selectedReceipt: ArchiveReceipt?
    @GestureState private var carouselDragOffset: CGFloat = 0
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

        if controller.receipts.isEmpty {
            return .noReceipts
        }

        if controller.selectedSubcategory != nil {
            return .noSubcategoryReceipts
        }

        return .noResults
    }

    var shouldShowRegisterEmptyState: Bool {
        switch emptyStateStyle {
        case .noReceipts, .noSubcategoryReceipts:
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
                receiptCardItem(item.receipt)
                    .id(item.id)
                    .scaleEffect(
                        x: item.position == .current ? 1.0 : ArchiveCarouselLayout.sideCardWidthScale,
                        y: item.position == .current ? 1.0 : ArchiveCarouselLayout.sideCardHeightScale
                    )
                    .opacity(item.position == .current ? 1.0 : ArchiveCarouselLayout.sideCardOpacity)
                    .offset(y: item.position == .current ? 0 : ArchiveCarouselLayout.sideCardYOffset)
            }
        }
        .frame(width: carouselContentWidth)
        .offset(x: carouselBaseOffset(screenWidth: screenWidth) - carouselDragOffset)
        .frame(width: screenWidth, alignment: .leading)
        .contentShape(Rectangle())
        .animation(ArchiveCarouselLayout.animation, value: focusedReceiptIndex)
        .animation(.interactiveSpring(response: 0.24, dampingFraction: 0.86), value: carouselDragOffset)
        .gesture(carouselDragGesture)
        .clipped()
        .onAppear {
            syncFocusedReceiptIndexWithCurrentReceipts()
        }
        .onChange(of: carouselReceiptIDs) { _, _ in
            syncFocusedReceiptIndexWithCurrentReceipts()
        }
    }

    func carouselSideMargin(screenWidth: CGFloat) -> CGFloat {
        max((screenWidth - ArchiveReceiptCardLayout.width) / 2, 24)
    }

    func emptyReceiptTopPadding(availableHeight: CGFloat) -> CGFloat {
        let preferredTopPadding: CGFloat = 49
        let minimumBottomPadding: CGFloat = 30
        let receiptHeight = ArchiveReceiptCardLayout.bodyHeight + ArchiveReceiptCardLayout.edgeHeight * 2
        let maximumTopPadding = availableHeight - receiptHeight - minimumBottomPadding

        return min(preferredTopPadding, max(0, maximumTopPadding))
    }

    func receiptCardItem(_ receipt: ArchiveReceipt) -> some View {
        Button {
            selectedReceipt = receipt
        } label: {
            ArchiveReceiptCard(receipt: receipt)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(receiptCardAccessibilityLabel(for: receipt))
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

    var carouselDragGesture: some Gesture {
        DragGesture()
            .updating($carouselDragOffset) { value, state, _ in
                guard carouselState.receipts.count > 1 else {
                    return
                }

                state = value.translation.width
            }
            .onEnded { value in
                moveFocusedReceiptIfNeeded(translationWidth: value.translation.width)
            }
    }

    func carouselBaseOffset(screenWidth: CGFloat) -> CGFloat {
        let centeredCardOffset = (screenWidth - ArchiveReceiptCardLayout.width) / 2

        guard carouselDisplayItems.count > 1 else {
            return centeredCardOffset
        }

        return centeredCardOffset - carouselPageWidth
    }

    func moveFocusedReceiptIfNeeded(translationWidth: CGFloat) {
        guard carouselState.receipts.count > 1 else {
            return
        }

        if translationWidth <= -ArchiveCarouselLayout.swipeThreshold {
            withAnimation(ArchiveCarouselLayout.animation) {
                focusedReceiptIndex = carouselState.previousIndex(from: focusedReceiptIndex)
            }
        } else if translationWidth >= ArchiveCarouselLayout.swipeThreshold {
            withAnimation(ArchiveCarouselLayout.animation) {
                focusedReceiptIndex = carouselState.nextIndex(from: focusedReceiptIndex)
            }
        }

        focusedReceiptID = carouselState.receipts[focusedReceiptIndex].id
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
