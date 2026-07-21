//
//  RegisterColorChip.swift
//  JiguJagu
//
//

import SwiftUI

struct RegisterColorChip: View {
    let option: RegisterColorOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                swatch

                Text(option.title)
                    .font(.pretendard.head3)
                    .foregroundStyle(isSelected ? Color.white : Color.grayScale500)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(isSelected ? Color.primary400 : Color.grayScale100)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(option.title) 색상")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    @ViewBuilder
    private var swatch: some View {
        switch option {
        case .black:
            Circle()
                .fill(Color.grayScale900)
                .frame(width: Layout.swatchSize, height: Layout.swatchSize)
        case .white:
            Circle()
                .fill(Color.white)
                .frame(width: Layout.swatchSize, height: Layout.swatchSize)
                .overlay {
                    Circle()
                        .stroke(Color.grayScale300, lineWidth: 1)
                }
        case .colored:
            Circle()
                .fill(
                    AngularGradient(
                        colors: [
                            .red,
                            .yellow,
                            .green,
                            .blue,
                            .purple,
                            .red
                        ],
                        center: .center
                    )
                )
                .frame(width: Layout.swatchSize, height: Layout.swatchSize)
        }
    }
}

private enum Layout {
    static let swatchSize: CGFloat = 18
}

#Preview {
    HStack(spacing: 8) {
        RegisterColorChip(option: .black, isSelected: true, action: {})
        RegisterColorChip(option: .white, isSelected: false, action: {})
        RegisterColorChip(option: .colored, isSelected: false, action: {})
    }
    .padding(16)
}
