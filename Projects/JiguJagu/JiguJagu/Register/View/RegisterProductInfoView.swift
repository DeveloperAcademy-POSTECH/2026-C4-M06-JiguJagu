//
//  RegisterProductInfoView.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterProductInfoView: View {
    let draft: RegisterDraft
    let onBack: () -> Void

    @State private var productName = ""
    @State private var brandName = ""
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

// MARK: - Subviews
extension RegisterProductInfoView {

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

            Text("정확하지 않아도 괜찮아요! \"검정 니트\"처럼\n나만 알아볼 수 있는 이름이면 충분해요.")
                .font(.pretendard.body4)
                .foregroundStyle(Color.grayScale900)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var inputSection: some View {
        VStack(spacing: 12) {
            RegisterProductInputField(
                label: "제품명",
                placeholder: "제품명이나 옷 이름을 등록해주세요",
                focus: .productName,
                focusedField: $focusedField,
                text: $productName
            )

            RegisterProductInputField(
                label: "브랜드",
                placeholder: "브랜드명을 입력해주세요",
                focus: .brandName,
                focusedField: $focusedField,
                text: $brandName
            )
        }
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
        onBack: {}
    )
}
