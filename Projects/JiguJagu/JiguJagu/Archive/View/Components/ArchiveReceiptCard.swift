//
//  ArchiveReceiptCard.swift
//  JiguJagu
//
//

import SwiftUI

enum ArchiveReceiptCardLayout {
    static let width: CGFloat = 266
    static let edgeHeight: CGFloat = 18
    static let bodyHeight: CGFloat = 488
}

struct ArchiveReceiptCard: View {
    let receipt: ArchiveReceipt

    init(receipt: ArchiveReceipt) {
        self.receipt = receipt
    }

    var body: some View {
        VStack(spacing: 0) {
            ReceiptTornEdge()
                .fill(Color.BG)
                .frame(height: ArchiveReceiptCardLayout.edgeHeight)

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
            .frame(
                width: ArchiveReceiptCardLayout.width,
                height: ArchiveReceiptCardLayout.bodyHeight,
                alignment: .top
            )
            .background(Color.BG)

            ReceiptTornEdge()
                .fill(Color.BG)
                .frame(height: ArchiveReceiptCardLayout.edgeHeight)
                .rotationEffect(.degrees(180))
        }
        .frame(width: ArchiveReceiptCardLayout.width)
    }
}

private extension ArchiveReceiptCard {
    var receiptHeader: some View {
        HStack {
            Text("Product")
                .font(.pretendard.body2)
                .foregroundStyle(Color.brown900)

            Spacer()

            Text(receipt.categoryPath)
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown200)
        }
    }

    var productInfo: some View {
        VStack(spacing: 14) {
            VStack(spacing: 4) {
                Text(receipt.brandName)
                    .font(.pretendard.head1)
                    .tracking(0.4)
                    .foregroundStyle(Color.brown900)

                Text(receipt.productName)
                    .font(.pretendard.body2)
                    .foregroundStyle(Color.brown900)
                    .multilineTextAlignment(.center)
            }

            Group {
                if let localImage = receipt.localImage {
                    // 1순위: 누끼 딴 로컬 이미지
                    Image(uiImage: localImage)
                        .resizable()
                        .scaledToFit()
                } else if let urlString = receipt.productImageURL,
                          let url = URL(string: urlString) {
                    // 2순위: 쇼핑 API 상품 이미지 (URL)
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .empty:
                            ProgressView()
                        case .failure:
                            Image(receipt.productImageName)
                                .resizable()
                                .scaledToFit()
                        @unknown default:
                            Image(receipt.productImageName)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                } else {
                    // 3순위: 에셋 이미지
                    Image(receipt.productImageName)
                        .resizable()
                        .scaledToFit()
                }
            }
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
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown900)

            Spacer()

            Text(receipt.archiveDateText)
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown200)
        }
    }

    var dottedDivider: some View {
        Text(String(repeating: "*", count: 56))
            .font(.system(size: 8, weight: .bold, design: .monospaced))
            .foregroundStyle(Color.grayScale900)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }

    func materialRow(_ material: Material) -> some View {
        HStack {
            Text(material.name)
                .foregroundStyle(materialNameColor(for: material))
            Spacer()
            Text("\(material.percentage)%")
                .foregroundStyle(Color.black)
        }
        .font(materialFont(for: material))
    }

    func materialFont(for material: Material) -> Font {
        material.percentage == receipt.maxMaterialPercentage ? .pretendard.body1 : .pretendard.body3
    }

    func materialNameColor(for material: Material) -> Color {
        material.percentage == receipt.maxMaterialPercentage ? .primary800 : .brown900
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
