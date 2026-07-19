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
                .frame(height: 36)

            VStack(spacing: 26) {
                receiptHeader

                dottedDivider

                productInfo

                materialInfo

                dottedDivider

                dateInfo
            }
            .padding(.horizontal, 48)
            .padding(.vertical, 34)
            .background(Color.BG)

            ReceiptTornEdge()
                .fill(Color.BG)
                .frame(height: 36)
                .rotationEffect(.degrees(180))
        }
        .frame(width: 532)
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
        VStack(spacing: 24) {
            VStack(spacing: 8) {
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
                .frame(height: 268)
                .overlay {
                    Gradient.Clothes
                }
        }
    }

    var materialInfo: some View {
        VStack(spacing: 18) {
            BarcodeView(materials: receipt.materials)

            VStack(spacing: 8) {
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
        Text(String(repeating: "*", count: 68))
            .font(.system(size: 12, weight: .bold, design: .monospaced))
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
        .font(material.percentage == maxMaterialPercentage ? .pretendard.head1 : .pretendard.head2)
        .foregroundStyle(Color.grayScale900)
    }

    var maxMaterialPercentage: Int {
        receipt.materials.map(\.percentage).max() ?? 0
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
