//
//  RegisterProductInputField.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterProductInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: Layout.contentSpacing) {
            Text(label)
                .font(.pretendard.body4)
                .foregroundStyle(Color.grayScale500)
                .lineLimit(1)
                .frame(width: Layout.labelWidth, alignment: .leading)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .foregroundStyle(Color.grayScale300)
            )
            .font(.pretendard.body4)
            .foregroundStyle(Color.grayScale900)
            .lineLimit(1)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .textContentType(.none)
            .submitLabel(.done)

            Button {
                text.removeAll()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.grayScale300)
                    .frame(width: Layout.clearButtonSize, height: Layout.clearButtonSize)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(label) 입력값 지우기")
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .frame(height: Layout.height)
        .background(Color.grayScale50)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
    }
}

private enum Layout {
    static let height: CGFloat = 50
    static let cornerRadius: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let contentSpacing: CGFloat = 20
    static let labelWidth: CGFloat = 61
    static let clearButtonSize: CGFloat = 24
}

#Preview {
    VStack(spacing: 12) {
        RegisterProductInputField(
            label: "제품명",
            placeholder: "제품명이나 옷 이름을 등록해주세요",
            text: .constant("")
        )

        RegisterProductInputField(
            label: "브랜드",
            placeholder: "브랜드명을 입력해주세요",
            text: .constant("오래입자구")
        )
    }
    .padding(16)
}
