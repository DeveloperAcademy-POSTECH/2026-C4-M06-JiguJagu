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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            content

            Spacer()
        }
        .background(Color.white)
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

            VStack(alignment: .leading, spacing: 8) {
                Text("제품명을 입력해주세요")
                    .font(.pretendard.head0)
                    .foregroundStyle(Color.grayScale900)

                Text(summaryText)
                    .font(.pretendard.body4)
                    .foregroundStyle(Color.grayScale600)
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.contentTopPadding)
    }

    private var stepSection: some View {
        RegisterStepIndicatorView(currentStep: 3, totalSteps: 3)
    }

    private var summaryText: String {
        var values = [draft.mainCategory.displayName]

        if let subcategory = draft.subcategory {
            values.append(subcategory.title)
        }

        if let color = draft.color {
            values.append(color.title)
        }

        return values.joined(separator: " · ")
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
