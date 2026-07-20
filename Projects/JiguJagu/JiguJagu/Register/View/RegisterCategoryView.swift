//
//  RegisterCategoryView.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct RegisterCategoryView: View {
    let onBack: () -> Void
    let onNext: (RegisterMainCategory) -> Void

    @State private var selectedCategory: RegisterMainCategory?
    private let categories = RegisterCategoryItem.allCases

    init(
        onBack: @escaping () -> Void = {},
        onNext: @escaping (RegisterMainCategory) -> Void = { _ in }
    ) {
        self.onBack = onBack
        self.onNext = onNext
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            content

            Spacer(minLength: 0)

            nextButton
        }
        .background(Color.white)
    }
}

// MARK: - Subviews
extension RegisterCategoryView {

    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            RegisterStepIndicatorView(currentStep: 1, totalSteps: 3)
            titleSection
            categoryGrid
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.contentTopPadding)
    }

    private var header: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(Color.grayScale900)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로가기")

            Spacer()

            Image("BrownLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 108, height: 28)
                .accessibilityLabel("오래입자구")

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.headerTopPadding)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("어떤 옷을 등록하실 건가요?")
                .font(.pretendard.head0)
                .foregroundStyle(Color.grayScale900)

            Text("해당되는 카테고리를 골라주세요")
                .font(.pretendard.body4)
                .foregroundStyle(Color.grayScale900)
        }
        .accessibilityElement(children: .combine)
    }

    private var categoryGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Layout.gridColumnSpacing),
                GridItem(.flexible(), spacing: Layout.gridColumnSpacing)
            ],
            spacing: Layout.gridRowSpacing
        ) {
            ForEach(categories) { category in
                RegisterCategoryCardView(
                    title: category.title,
                    imageName: category.imageName,
                    selectedImageName: category.selectedImageName,
                    imageSize: category.imageSize,
                    isSelected: selectedCategory == category.category
                ) {
                    selectedCategory = category.category
                }
            }
        }
    }

    private var nextButton: some View {
        Button {
            guard let selectedCategory else { return }
            onNext(selectedCategory)
        } label: {
            Text("다음")
                .font(.pretendard.head3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: Layout.nextButtonHeight)
                .background(Color.primary500)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(selectedCategory == nil)
        .opacity(selectedCategory == nil ? 0.45 : 1)
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.bottom, Layout.nextButtonBottomPadding)
        .accessibilityLabel(nextButtonAccessibilityLabel)
        .accessibilityHint("선택한 카테고리로 옷 등록을 이어갑니다")
    }

    private var nextButtonAccessibilityLabel: String {
        guard let selectedCategory = selectedCategory else {
            return "카테고리 선택 후 다음"
        }

        return "\(selectedCategory.displayName) 선택 후 다음"
    }
}

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 14
    static let contentTopPadding: CGFloat = 36
    static let gridColumnSpacing: CGFloat = 20
    static let gridRowSpacing: CGFloat = 24
    static let nextButtonHeight: CGFloat = 52
    static let nextButtonBottomPadding: CGFloat = 52
}

private struct RegisterCategoryItem: Identifiable {
    let category: RegisterMainCategory
    let imageName: String
    let selectedImageName: String?
    let imageSize: CGSize

    var id: String {
        category.id
    }

    var title: String {
        category.displayName
    }

    static let allCases: [RegisterCategoryItem] = [
        RegisterCategoryItem(
            category: .tops,
            imageName: "RegisterTops",
            selectedImageName: nil,
            imageSize: CGSize(width: 94, height: 73)
        ),
        RegisterCategoryItem(
            category: .bottoms,
            imageName: "RegisterBottoms",
            selectedImageName: nil,
            imageSize: CGSize(width: 71, height: 73)
        ),
        RegisterCategoryItem(
            category: .outers,
            imageName: "RegisterOuters",
            selectedImageName: nil,
            imageSize: CGSize(width: 96, height: 73)
        ),
        RegisterCategoryItem(
            category: .etc,
            imageName: "RegisterEtc",
            selectedImageName: "RegisterEtcSelected",
            imageSize: CGSize(width: 146, height: 59)
        )
    ]
}

#Preview {
    RegisterCategoryView()
}
