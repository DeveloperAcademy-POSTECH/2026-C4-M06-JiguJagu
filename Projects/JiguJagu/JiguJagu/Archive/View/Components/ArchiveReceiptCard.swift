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

            VStack(spacing: 16) {
                receiptHeader

                dottedDivider

                productInfo

                materialInfo

                dottedDivider

                dateInfo
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 22)
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
        VStack(spacing: 16) {
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
                .frame(height: 154)
                .overlay {
                    Gradient.Clothes
                }
        }
    }

    var materialInfo: some View {
        VStack(spacing: 11) {
            ArchiveMaterialBarcodeView(materials: receipt.materials)
                .frame(height: 20)

            VStack(spacing: 5) {
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
    private let colors: [Color] = [
        .brown600,
        .progress2,
        .progress3,
        .progress4
    ]

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 1.5) {
                ForEach(materials.indices, id: \.self) { index in
                    let material = materials[index]
                    let segmentWidth = segmentWidth(
                        for: material,
                        totalWidth: geometry.size.width
                    )

                    barcodeSegment(
                        width: segmentWidth,
                        color: color(for: material, at: index)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private extension ArchiveMaterialBarcodeView {
    func barcodeSegment(width: CGFloat, color: Color) -> some View {
        HStack(alignment: .center, spacing: 1) {
            let barWidths = [1.0, 2.5, 1.5, 3.0, 1.0, 2.0]
            let barCount = max(Int(width / 3), 1)

            ForEach(0..<barCount, id: \.self) { index in
                Rectangle()
                    .fill(color)
                    .frame(width: barWidths[index % barWidths.count], height: 20)
            }
        }
        .frame(width: width, alignment: .leading)
        .clipped()
    }

    func segmentWidth(for material: Material, totalWidth: CGFloat) -> CGFloat {
        let availableWidth = totalWidth - CGFloat(max(materials.count - 1, 0)) * 1.5
        return availableWidth * CGFloat(material.percentage) / 100
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
