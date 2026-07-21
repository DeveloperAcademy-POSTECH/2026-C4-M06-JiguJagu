//
//  RegisterProductInputField.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

enum RegisterProductInputFocus: Hashable {
    case productName
    case brandName
}

struct RegisterProductInputField: View {
    let label: String
    let placeholder: String
    let focus: RegisterProductInputFocus
    let focusedField: FocusState<RegisterProductInputFocus?>.Binding
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
            // 제품명은 사용자가 입력한 그대로 유지되도록 키보드 제안을 끕니다.
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .textContentType(.none)
            .focused(focusedField, equals: focus)

            Button {
                text.removeAll()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.grayScale300)
                    .frame(width: Layout.clearButtonSize, height: Layout.clearButtonSize)
            }
            .buttonStyle(.plain)
            .opacity(text.isEmpty ? 0 : 1)
            .disabled(text.isEmpty)
            .accessibilityLabel("\(label) 입력값 지우기")
            .accessibilityHidden(text.isEmpty)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .frame(height: Layout.height)
        .background(Color.grayScale50)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .contentShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .onTapGesture {
            // 라벨이나 배경을 탭해도 입력 필드에 포커스가 잡히도록 합니다.
            focusedField.wrappedValue = focus
        }
        .accessibilityElement(children: .contain)
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
    RegisterProductInputFieldPreview()
}

private struct RegisterProductInputFieldPreview: View {
    @State private var productName = ""
    @State private var brandName = "오래입자구"
    @FocusState private var focusedField: RegisterProductInputFocus?

    var body: some View {
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
        .padding(16)
    }
}
