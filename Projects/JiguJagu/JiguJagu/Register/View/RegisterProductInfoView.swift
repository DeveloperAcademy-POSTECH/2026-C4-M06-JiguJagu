//
//  RegisterProductInfoView.swift
//  JiguJagu
//
//

import SwiftUI

struct RegisterProductInfoView: View {
    let draft: RegisterDraft
    let onBack: () -> Void
    let onNext: (RegisterProductInputState) -> Void

    @State private var inputState = RegisterProductInputState()
    @FocusState private var focusedField: RegisterProductInputFocus?

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissKeyboard()
                }

            VStack(alignment: .leading, spacing: 0) {
                header
                content

                Spacer()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissKeyboard()
                    }

                // 키보드가 활성화된 동안 하단 고정 버튼은 숨깁니다.
                if !isKeyboardFocused {
                    nextButton
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Subviews
extension RegisterProductInfoView {

    private var header: some View {
        RegisterHeaderView(onBack: onBack)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            stepSection

            titleSection
            inputSection
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.contentTopPadding)
    }

    private var stepSection: some View {
        RegisterStepIndicatorView(currentStep: 3, totalSteps: 3)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("제품 이름을 입력해주세요")
                .font(.pretendard.head0)
                .foregroundStyle(Color.grayScale900)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text("정확하지 않아도 괜찮아요! \"검정 니트\"처럼\n나만 알아볼 수 있는 이름이면 충분해요.")
                .font(.pretendard.body4)
                .foregroundStyle(Color.grayScale900)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private var inputSection: some View {
        VStack(spacing: 12) {
            RegisterProductInputField(
                label: "제품명",
                placeholder: "제품명이나 옷 이름을 등록해주세요",
                focus: .productName,
                focusedField: $focusedField,
                text: $inputState.productName
            )

            RegisterProductInputField(
                label: "브랜드",
                placeholder: "브랜드명을 입력해주세요",
                focus: .brandName,
                focusedField: $focusedField,
                text: $inputState.brandName
            )
        }
        .accessibilityElement(children: .contain)
    }

    private var nextButton: some View {
        Button {
            guard isNextButtonEnabled else { return }
            dismissKeyboard()
            onNext(inputState)
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

    private var isNextButtonEnabled: Bool {
        // 다음 단계로 이동하기 위한 최소 입력값은 제품명입니다.
        inputState.hasProductName
    }

    private var isKeyboardFocused: Bool {
        focusedField != nil
    }

    private var nextButtonBackgroundColor: Color {
        isNextButtonEnabled ? Color.primary500 : Color.grayScale300
    }

    private var nextButtonAccessibilityLabel: String {
        if isNextButtonEnabled {
            return "\(inputState.trimmedProductName) 입력 후 다음"
        }

        return "제품명 입력 후 다음"
    }

    private var nextButtonAccessibilityHint: String {
        if isNextButtonEnabled {
            return "입력한 제품 정보로 옷 등록을 이어갑니다"
        }

        return "제품명을 입력해야 다음 단계로 이동할 수 있습니다"
    }
}

// MARK: - Actions
extension RegisterProductInfoView {

    private func dismissKeyboard() {
        focusedField = nil
    }
}

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 14
    static let contentTopPadding: CGFloat = 36
}

#Preview {
    RegisterProductInfoView(
        draft: RegisterDraft(
            mainCategory: .etc,
            subcategory: nil,
            color: nil
        ),
        onBack: {},
        onNext: { _ in }
    )
}
