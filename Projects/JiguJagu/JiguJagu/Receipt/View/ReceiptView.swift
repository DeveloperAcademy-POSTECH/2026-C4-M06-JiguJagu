//
//  ReceiptView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI
import SwiftData
import UIKit
import Combine

enum ReceiptDisplayMode {
    case generated
    case archived

    var initialReceiptOffset: CGFloat {
        switch self {
        case .generated:
            return -1200
        case .archived:
            return 0
        }
    }

    var shouldStartPrinting: Bool {
        self == .generated
    }

    var allowsPrintSkip: Bool {
        self == .generated
    }

    var showsArchiveAction: Bool {
        self == .generated
    }

    var showsPrinter: Bool {
        self == .generated
    }

    var receiptStackSpacing: CGFloat {
        switch self {
        case .generated:
            return -50
        case .archived:
            return 0
        }
    }

    var ignoredSafeAreaEdges: Edge.Set {
        switch self {
        case .generated:
            return []
        case .archived:
            return .top
        }
    }

    var topActionsTopPadding: CGFloat {
        switch self {
        case .generated:
            return 0
        case .archived:
            return 48
        }
    }

    var topActionsBottomPadding: CGFloat {
        switch self {
        case .generated:
            return 0
        case .archived:
            return 8
        }
    }

    var receiptScrollVerticalPadding: CGFloat {
        switch self {
        case .generated:
            return 16
        case .archived:
            return 0
        }
    }
}

struct ReceiptView: View {
    @Environment(\.modelContext) private var modelContext
    
    let clothing: Clothing
    let localImage: UIImage?
    let registeredDate: Date
    let displayMode: ReceiptDisplayMode
    let onClose: () -> Void
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }
    
    @State private var controller = ReceiptAnimationController()
    @State private var isPrinting = false
    @State private var showArchive = false
    @State private var isSavingToArchive = false
    @State private var archiveSaveErrorMessage: String?
    @StateObject private var shareController = ReceiptShareController()
    private let receiptStore = SwiftDataReceiptStore()

    init(
        clothing: Clothing,
        localImage: UIImage? = nil,
        registeredDate: Date = Date(),
        displayMode: ReceiptDisplayMode = .generated,
        onClose: @escaping () -> Void = {
            NotificationCenter.default.post(name: .goHome, object: nil)
        }
    ) {
        self.clothing = clothing
        self.localImage = localImage
        self.registeredDate = registeredDate
        self.displayMode = displayMode
        self.onClose = onClose
        _controller = State(
            initialValue: ReceiptAnimationController(
                receiptOffset: displayMode.initialReceiptOffset
            )
        )
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: displayMode.receiptStackSpacing) {
                receiptTopArea
                receiptScrollView
            }
            .ignoresSafeArea(edges: displayMode.ignoredSafeAreaEdges)
            .scrollBounceBehavior(.basedOnSize)
            .background {
                ZStack(alignment: .top) {
                    Image("MainBG")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 532, height: 912)
                        .clipped()
                        .opacity(0.6)
                    
                    TopGradientOverlay()
                        .allowsHitTesting(false)
                }
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
            .onAppear {
                startReceiptPresentationIfNeeded(proxy: proxy)
                DispatchQueue.main.async {
                    shareController.makeShareImage(
                        from: ReceiptContentView(
                            clothing: clothing,
                            localImage: localImage,
                            formatter: formatter,
                            registeredDate: registeredDate
                        ),
                        size: CGSize(width: 306, height: 900)
                    )
                }
            }
            .onTapGesture {
                skipReceiptPresentationIfNeeded(proxy: proxy)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showArchive) {
            ArchiveView(
                initialCategory: .all,
                onBackButtonTap: { showArchive = false }
            )
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
        .alert(
            "보관함에 저장하지 못했어요",
            isPresented: isShowingArchiveSaveError
        ) {
            Button("확인") {
                archiveSaveErrorMessage = nil
            }
        } message: {
            Text(archiveSaveErrorMessage ?? "잠시 후 다시 시도해주세요.")
        }
    }
}

private extension ReceiptView {
    var isShowingArchiveSaveError: Binding<Bool> {
        Binding(
            get: { archiveSaveErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    archiveSaveErrorMessage = nil
                }
            }
        )
    }

    @ViewBuilder
    var receiptTopArea: some View {
        if displayMode.showsPrinter {
            ZStack(alignment: .top) {
                Image("ReceiptPrinter")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 355.72)
                    .padding(.top, 50)

                receiptTopActions
            }
        } else {
            receiptTopActions
                .padding(.top, displayMode.topActionsTopPadding)
                .padding(.bottom, displayMode.topActionsBottomPadding)
        }
    }

    var receiptTopActions: some View {
        ReceiptTopActions(
            shareImage: shareController.shareImage,
            onClose: onClose,
            onArchive: saveReceiptToArchive,
            showsArchiveButton: displayMode.showsArchiveAction,
            isArchiveButtonDisabled: isSavingToArchive
        )
    }

    var receiptScrollView: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
                ReceiptContentView(
                    clothing: clothing,
                    localImage: localImage,
                    formatter: formatter,
                    registeredDate: registeredDate
                )
                .offset(y: controller.receiptOffset)
            }
            .clipped()
            .id("receiptBottom")
        }
        .padding(.vertical, displayMode.receiptScrollVerticalPadding)
    }

    func startReceiptPresentationIfNeeded(proxy: ScrollViewProxy) {
        guard displayMode.shouldStartPrinting else {
            return
        }

        controller.startPrinting(proxy: proxy)
    }

    func skipReceiptPresentationIfNeeded(proxy: ScrollViewProxy) {
        guard displayMode.allowsPrintSkip else {
            return
        }

        controller.skipPrinting(proxy: proxy)
    }

    func saveReceiptToArchive() {
        guard !isSavingToArchive else {
            return
        }

        isSavingToArchive = true

        do {
            let receipt = ArchiveReceipt(
                from: clothing,
                localImage: localImage,
                registeredDate: registeredDate
            )
            try receiptStore.save(receipt, in: modelContext)
            showArchive = true
        } catch {
            archiveSaveErrorMessage = "영수증 저장 중 문제가 생겼어요."
        }

        isSavingToArchive = false
    }
}

#Preview {
    ReceiptView(
        clothing: Clothing.mocks[0]
    )
}
