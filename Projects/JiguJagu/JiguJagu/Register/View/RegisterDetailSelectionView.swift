//
//  RegisterDetailSelectionView.swift
//  JiguJagu
//
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
            RegisterHeaderView(onBack: onBack)

            VStack(alignment: .leading, spacing: 32) {
                RegisterStepIndicatorView(currentStep: 2, totalSteps: 3)
                titleSection
                subcategorySelector
                colorSelector
                    .padding(.top, Layout.colorSectionAdditionalTopPadding)
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

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category.detailTitle)
                .font(.pretendard.head0)
                .foregroundStyle(Color.grayScale900)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text("해당되는 카테고리를 골라주세요")
                .font(.pretendard.body4)
                .foregroundStyle(Color.grayScale900)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private var subcategorySelector: some View {
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(category.displayName) 하위 카테고리 선택")
        .accessibilityValue(selectedSubcategory?.title ?? "선택 안 됨")
    }

    private var colorSelector: some View {
        VStack(alignment: .leading, spacing: Layout.selectorTopSpacing) {
            VStack(alignment: .leading, spacing: 8) {
                Text("제품 색상을 골라주세요")
                    .font(.pretendard.head1)
                    .foregroundStyle(Color.grayScale900)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text("제품 색상을 알아두면 세탁방법을\n더 잘 알려드릴수 있어요")
                    .font(.pretendard.body4)
                    .foregroundStyle(Color.grayScale900)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            RegisterChipFlowLayout(
                horizontalSpacing: Layout.chipHorizontalSpacing,
                verticalSpacing: Layout.colorChipVerticalSpacing
            ) {
                ForEach(RegisterColorOption.allCases) { color in
                    RegisterColorChip(
                        option: color,
                        isSelected: selectedColor == color
                    ) {
                        selectedColor = color
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("색상 선택")
        .accessibilityValue(selectedColor?.title ?? "선택 안 됨")
    }

    private var nextButton: some View {
        Button {
            guard let selectedDetailSelection else { return }
            onNext(selectedDetailSelection)
        } label: {
            Text("다음")
                .font(.pretendard.head3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: RegisterActionButtonLayout.nextButtonHeight)
                .background(nextButtonBackgroundColor)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!isNextButtonEnabled)
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.bottom, RegisterActionButtonLayout.nextButtonBottomPadding)
        .accessibilityLabel(nextButtonAccessibilityLabel)
        .accessibilityHint(nextButtonAccessibilityHint)
        .animation(.easeInOut(duration: 0.15), value: isNextButtonEnabled)
    }

    private var selectedDetailSelection: RegisterDetailSelection? {
        guard let selectedSubcategory, let selectedColor else {
            return nil
        }

        return RegisterDetailSelection(
            mainCategory: category,
            subcategory: selectedSubcategory,
            color: selectedColor
        )
    }

    private var isNextButtonEnabled: Bool {
        selectedDetailSelection != nil
    }

    private var nextButtonBackgroundColor: Color {
        isNextButtonEnabled ? Color.primary500 : Color.grayScale300
    }

    private var nextButtonAccessibilityLabel: String {
        switch (selectedSubcategory, selectedColor) {
        case (.some(let subcategory), .some(let color)):
            return "\(subcategory.title), \(color.title) 선택 후 다음"
        case (.some(let subcategory), .none):
            return "\(subcategory.title), 색상 선택 후 다음"
        case (.none, .some(let color)):
            return "\(color.title), 하위 카테고리 선택 후 다음"
        case (.none, .none):
            return "하위 카테고리와 색상 선택 후 다음"
        }
    }

    private var nextButtonAccessibilityHint: String {
        if isNextButtonEnabled {
            return "선택한 상세 정보로 옷 등록을 이어갑니다"
        }

        return "하위 카테고리와 색상을 모두 선택해야 다음 단계로 이동할 수 있습니다"
    }
}

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 14
    static let contentTopPadding: CGFloat = 36
    static let selectorTopSpacing: CGFloat = 32
    static let chipHorizontalSpacing: CGFloat = 8
    static let chipVerticalSpacing: CGFloat = 16
    static let colorChipVerticalSpacing: CGFloat = 12
    static let colorSectionAdditionalTopPadding: CGFloat = 84
}

#Preview {
    RegisterDetailSelectionView(
        category: .tops,
        onBack: {},
        onNext: { _ in }
    )
}
