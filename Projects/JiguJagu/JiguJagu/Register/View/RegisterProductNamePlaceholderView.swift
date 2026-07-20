//
//  RegisterProductNamePlaceholderView.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterProductNamePlaceholderView: View {
    let draft: RegisterDraft
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Button(action: onBack) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(Color.grayScale900)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로가기")

            RegisterStepIndicatorView(currentStep: 3, totalSteps: 3)

            VStack(alignment: .leading, spacing: 8) {
                Text("제품명을 입력해주세요")
                    .font(.pretendard.head0)
                    .foregroundStyle(Color.grayScale900)

                Text(summaryText)
                    .font(.pretendard.body4)
                    .foregroundStyle(Color.grayScale600)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 73)
        .background(Color.white)
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

#Preview {
    RegisterProductNamePlaceholderView(
        draft: RegisterDraft(
            mainCategory: .etc,
            subcategory: nil,
            color: nil
        ),
        onBack: {}
    )
}
