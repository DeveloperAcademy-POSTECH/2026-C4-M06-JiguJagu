//
//  RegisterCategoryView.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct RegisterCategoryView: View {
    let onBack: () -> Void
    let onNext: (String) -> Void

    @State private var selectedCategoryID: String?
    private let categories = RegisterCategoryItem.allCases

    init(
        onBack: @escaping () -> Void = {},
        onNext: @escaping (String) -> Void = { _ in }
    ) {
        self.onBack = onBack
        self.onNext = onNext
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            content

            Spacer()
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
                    imageSize: category.imageSize,
                    isSelected: selectedCategoryID == category.id
                ) {
                    selectedCategoryID = category.id
                }
            }
        }
    }

    private var nextButton: some View {
        Button {
            guard let selectedCategoryID else { return }
            onNext(selectedCategoryID)
        } label: {
            Text("다음")
                .font(.pretendard.head3)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.primary500)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 52)
        .accessibilityLabel(nextButtonAccessibilityLabel)
    }

    private var nextButtonAccessibilityLabel: String {
        guard let selectedCategory = selectedCategory else {
            return "카테고리 선택 후 다음"
        }

        return "\(selectedCategory.title) 선택 후 다음"
    }

    private var selectedCategory: RegisterCategoryItem? {
        categories.first { $0.id == selectedCategoryID }
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
