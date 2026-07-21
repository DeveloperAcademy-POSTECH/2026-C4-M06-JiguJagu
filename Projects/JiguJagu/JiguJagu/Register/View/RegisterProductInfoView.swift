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
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.contentTopPadding)
    }

    private var stepSection: some View {
        RegisterStepIndicatorView(currentStep: 3, totalSteps: 3)
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
