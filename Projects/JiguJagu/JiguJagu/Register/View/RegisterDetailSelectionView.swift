//
//  RegisterDetailSelectionView.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterDetailSelectionView: View {
    let category: RegisterMainCategory
    let onBack: () -> Void
    let onNext: (RegisterDetailSelection) -> Void

    @State private var selectedSubcategory: RegisterSubcategory?
    @State private var selectedColor: RegisterColorOption?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            VStack(alignment: .leading, spacing: 32) {
                RegisterStepIndicatorView(currentStep: 2, totalSteps: 3)
                titleSection
                subcategorySelector
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.contentTopPadding)

            Spacer(minLength: 0)

            nextButton
        }
        .background(Color.white)
    }
}

// MARK: - Subviews
extension RegisterDetailSelectionView {

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
            Text(category.detailTitle)
                .font(.pretendard.head0)
                .foregroundStyle(Color.grayScale900)

            Text("해당되는 카테고리를 골라주세요")
                .font(.pretendard.body4)
                .foregroundStyle(Color.grayScale900)
        }
        .accessibilityElement(children: .combine)
    }

    private var subcategorySelector: some View {
        VStack(alignment: .leading, spacing: 0) {
            RegisterChipFlowLayout(
                horizontalSpacing: Layout.chipHorizontalSpacing,
                verticalSpacing: Layout.chipVerticalSpacing
            ) {
                ForEach(category.subcategories) { subcategory in
                    RegisterSelectionChip(
                        title: subcategory.title,
                        isSelected: selectedSubcategory == subcategory
                    ) {
                        selectedSubcategory = subcategory
                    }
                }
            }

            Color.clear
                .frame(height: Layout.colorSectionReservedHeight)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(category.displayName) 하위 카테고리 선택")
    }

    private var nextButton: some View {
        Button {
            guard let selectedSubcategory, let selectedColor else { return }

            onNext(
                RegisterDetailSelection(
                    mainCategory: category,
                    subcategory: selectedSubcategory,
                    color: selectedColor
                )
            )
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
        .disabled(selectedSubcategory == nil || selectedColor == nil)
        .opacity(selectedSubcategory == nil || selectedColor == nil ? 0.45 : 1)
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.bottom, Layout.nextButtonBottomPadding)
        .accessibilityLabel("하위 카테고리와 색상 선택 후 다음")
    }
}

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 14
    static let contentTopPadding: CGFloat = 36
    static let chipHorizontalSpacing: CGFloat = 8
    static let chipVerticalSpacing: CGFloat = 16
    static let colorSectionReservedHeight: CGFloat = 260
    static let nextButtonHeight: CGFloat = 52
    static let nextButtonBottomPadding: CGFloat = 52
}

#Preview {
    RegisterDetailSelectionView(
        category: .tops,
        onBack: {},
        onNext: { _ in }
    )
}
