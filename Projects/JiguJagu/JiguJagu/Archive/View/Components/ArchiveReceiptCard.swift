//
//  ArchiveReceiptCard.swift
//  JiguJagu
//
//  Created by Codex on 7/20/26.
//

import SwiftUI

struct ArchiveReceiptCard: View {
    let receipt: ArchiveReceipt

    init(receipt: ArchiveReceipt) {
        self.receipt = receipt
    }

    var body: some View {
        VStack(spacing: 0) {
            ReceiptTornEdge()
                .fill(Color.BG)
                .frame(height: 18)

            VStack(spacing: 14) {
                receiptHeader

                dottedDivider

                productInfo

                materialInfo

                dottedDivider

                dateInfo
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(Color.BG)

            ReceiptTornEdge()
                .fill(Color.BG)
                .frame(height: 18)
                .rotationEffect(.degrees(180))
        }
        .frame(width: 266)
    }
}

private extension ArchiveReceiptCard {
    var receiptHeader: some View {
        HStack {
            Text("Product")
                .font(.pretendard.head1)
                .foregroundStyle(Color.grayScale900)

            Spacer()

            Text(receipt.categoryPath)
                .font(.pretendard.head2)
                .foregroundStyle(Color.brown300)
        }
    }

    var productInfo: some View {
        VStack(spacing: 14) {
            VStack(spacing: 4) {
                Text(receipt.brandName)
                    .font(.pretendard.head0)
                    .foregroundStyle(Color.grayScale900)

                Text(receipt.productName)
                    .font(.pretendard.head1)
                    .foregroundStyle(Color.grayScale900)
                    .multilineTextAlignment(.center)
            }

            Image(receipt.productImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .overlay {
                    Gradient.Clothes
                }
        }
    }

    var materialInfo: some View {
        VStack(spacing: 9) {
            ArchiveMaterialBarcodeView(materials: receipt.materials)
                .frame(height: 20)

            VStack(spacing: 4) {
                ForEach(receipt.materials, id: \.name) { material in
                    materialRow(material)
                }
            }
        }
    }

    var dateInfo: some View {
        HStack {
            Text("Date")
                .font(.pretendard.head2)
                .foregroundStyle(Color.grayScale900)

            Spacer()

            Text(formattedDate)
                .font(.pretendard.head2)
                .foregroundStyle(Color.brown300)
        }
    }

    var dottedDivider: some View {
        Text(String(repeating: "*", count: 56))
            .font(.system(size: 8, weight: .bold, design: .monospaced))
            .foregroundStyle(Color.grayScale900)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: receipt.registeredDate)
    }

    func materialRow(_ material: Material) -> some View {
        HStack {
            Text(material.name)
            Spacer()
            Text("\(material.percentage)%")
        }
        .font(materialFont(for: material))
        .foregroundStyle(Color.grayScale900)
    }

    func materialFont(for material: Material) -> Font {
        let fontName = material.percentage == maxMaterialPercentage
        ? "Pretendard-SemiBold"
        : "Pretendard-Regular"

        return .custom(fontName, size: 14)
    }

    var maxMaterialPercentage: Int {
        receipt.materials.map(\.percentage).max() ?? 0
    }
}

private struct ArchiveMaterialBarcodeView: View {
    let materials: [Material]
    private let pattern = "535552853555383555386245523432525243564"
    private let colors: [Color] = [
        .brown600,
        .progress2,
        .progress3,
        .progress4
    ]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: scaledSpacing(totalWidth: geometry.size.width)) {
                ForEach(Array(pattern).indices, id: \.self) { index in
                    let value = Int(String(Array(pattern)[index])) ?? 1

                    Rectangle()
                        .fill(colorFor(index: index))
                        .frame(
                            width: CGFloat(value) * widthScale(totalWidth: geometry.size.width),
                            height: 20
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private extension ArchiveMaterialBarcodeView {
    func colorFor(index: Int) -> Color {
        let material = materialAt(index: index)

        return color(for: material, at: index)
    }

    func color(for material: Material, at index: Int) -> Color {
        switch material.name {
        case "Acrylic":
            return .brown600
        case "Polyester":
            return .progress2
        case "Wool":
            return .progress3
        case "Nylon":
            return .progress4
        case "Cotton":
            return .green600
        case "Rayon":
            return .primary500
        case "Span":
            return .grayScale500
        default:
            return colors[index % colors.count]
        }
    }

    func materialAt(index: Int) -> Material {
        let totalWidth = pattern.reduce(0) { result, char in
            result + (Int(String(char)) ?? 1)
        }

        let currentWidth = pattern
            .prefix(index + 1)
            .reduce(0) { result, char in
                result + (Int(String(char)) ?? 1)
            }

        let ratio = Double(currentWidth) / Double(totalWidth)
        var accumulated = 0.0

        for material in materials {
            accumulated += Double(material.percentage) / 100

            if ratio <= accumulated {
                return material
            }
        }

        return materials.last ?? Material(name: "Unknown", percentage: 0)
    }

    func widthScale(totalWidth: CGFloat) -> CGFloat {
        totalWidth / naturalWidth
    }

    func scaledSpacing(totalWidth: CGFloat) -> CGFloat {
        widthScale(totalWidth: totalWidth)
    }

    var naturalWidth: CGFloat {
        let barWidth = pattern.reduce(0) { result, char in
            result + (Int(String(char)) ?? 1)
        }

        let totalSpacing = max(pattern.count - 1, 0)

        return CGFloat(barWidth + totalSpacing)
    }
}

private struct ReceiptTornEdge: Shape {
    private let teethCount = 14

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let toothWidth = rect.width / CGFloat(teethCount)

        path.move(to: CGPoint(x: 0, y: rect.maxY))

        for index in 0..<teethCount {
            let startX = CGFloat(index) * toothWidth
            let middleX = startX + toothWidth / 2
            let endX = startX + toothWidth

            path.addLine(to: CGPoint(x: middleX, y: rect.minY))
            path.addLine(to: CGPoint(x: endX, y: rect.maxY))
        }

        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    ArchiveReceiptCard(
        receipt: ArchiveReceipt(
            id: "preview",
            brandName: "칙스",
            productName: "더블 스트라이프\n카라 니트",
            category: .tops,
            subcategory: ArchiveSubcategory.tops[0],
            productImageName: "MockProduct",
            registeredDate: Date(),
            materials: [
                Material(name: "Acrylic", percentage: 60),
                Material(name: "Polyester", percentage: 20),
                Material(name: "Wool", percentage: 15),
                Material(name: "Nylon", percentage: 5)
            ]
        )
    )
}
