//
//  RegisterSelectionChip.swift
//  JiguJagu
//
//  Created by Codex on 7/21/26.
//

import SwiftUI

struct RegisterSelectionChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pretendard.head3)
                .foregroundStyle(isSelected ? Color.white : Color.grayScale500)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(isSelected ? Color.primary400 : Color.grayScale100)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) 하위 카테고리")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

#Preview {
    HStack(spacing: 8) {
        RegisterSelectionChip(
            title: "티셔츠",
            isSelected: true,
            action: {}
        )

        RegisterSelectionChip(
            title: "피케/카라티",
            isSelected: false,
            action: {}
        )
    }
    .padding(16)
}
