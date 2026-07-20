//
//  RegisterCategoryCardView.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterCategoryCardView: View {
    let title: String
    let imageName: String
    let selectedImageName: String?
    let imageSize: CGSize
    let isSelected: Bool
    let action: () -> Void

    init(
        title: String,
        imageName: String,
        selectedImageName: String? = nil,
        imageSize: CGSize,
        isSelected: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.imageName = imageName
        self.selectedImageName = selectedImageName
        self.imageSize = imageSize
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                Text(title)
                    .font(.pretendard.head1)
                    .foregroundStyle(isSelected ? Color.white : Color.grayScale700)
                    .frame(height: 46)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Image(displayImageName)
                    .resizable()
                    .renderingMode(selectedImageName == nil && isSelected ? .template : .original)
                    .scaledToFit()
                    .foregroundStyle(Color.white)
                    .frame(width: imageSize.width, height: imageSize.height)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 204)
            .background(isSelected ? Color.primary400 : Color.grayScale100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) 카테고리")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    private var displayImageName: String {
        guard isSelected, let selectedImageName else {
            return imageName
        }

        return selectedImageName
    }
}

#Preview {
    HStack(spacing: 20) {
        RegisterCategoryCardView(
            title: "Tops",
            imageName: "RegisterTops",
            imageSize: CGSize(width: 94, height: 73),
            isSelected: true
        )

        RegisterCategoryCardView(
            title: "Bottoms",
            imageName: "RegisterBottoms",
            imageSize: CGSize(width: 71, height: 73)
        )
    }
    .padding(16)
}
