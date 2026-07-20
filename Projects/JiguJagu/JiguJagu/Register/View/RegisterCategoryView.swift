//
//  RegisterCategoryView.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct RegisterCategoryView: View {
    let onBack: () -> Void

    private let categories = RegisterCategoryItem.allCases

    init(onBack: @escaping () -> Void = {}) {
        self.onBack = onBack
    }

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
extension RegisterCategoryView {

    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            RegisterStepIndicatorView(currentStep: 1, totalSteps: 3)
            titleSection
            categoryGrid
        }
        .padding(.horizontal, 16)
        .padding(.top, 36)
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
        .padding(.horizontal, 16)
        .padding(.top, 60)
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
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ],
            spacing: 24
        ) {
            ForEach(categories) { category in
                RegisterCategoryCardView(
                    title: category.title,
                    imageName: category.imageName,
                    imageSize: category.imageSize
                )
            }
        }
    }
}

private struct RegisterCategoryItem: Identifiable {
    let id: String
    let title: String
    let imageName: String
    let imageSize: CGSize

    static let allCases: [RegisterCategoryItem] = [
        RegisterCategoryItem(
            id: "tops",
            title: "Tops",
            imageName: "RegisterTops",
            imageSize: CGSize(width: 94, height: 73)
        ),
        RegisterCategoryItem(
            id: "bottoms",
            title: "Bottoms",
            imageName: "RegisterBottoms",
            imageSize: CGSize(width: 71, height: 73)
        ),
        RegisterCategoryItem(
            id: "outers",
            title: "Outers",
            imageName: "RegisterOuters",
            imageSize: CGSize(width: 96, height: 73)
        ),
        RegisterCategoryItem(
            id: "etc",
            title: "Etc",
            imageName: "RegisterEtc",
            imageSize: CGSize(width: 146, height: 59)
        )
    ]
}

#Preview {
    RegisterCategoryView()
}
