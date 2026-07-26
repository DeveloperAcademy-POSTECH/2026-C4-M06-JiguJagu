//
//  ArchiveEmptyStateView.swift
//  JiguJagu
//
//

import SwiftUI

enum ArchiveEmptyStateStyle {
    case noReceipts
    case noCategoryReceipts(category: String)
    case noResults
    case loadFailed(message: String)
}

struct ArchiveEmptyStateView: View {
    let style: ArchiveEmptyStateStyle
    let onResetButtonTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            EmptyReceiptEdge()
                .fill(Color.BG)
                .frame(height: ArchiveReceiptCardLayout.edgeHeight)

            VStack(spacing: 0) {
                titleGroup
                    .padding(.top, 48)

                Image("ArchiveEmptyHanger")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(width: 117, height: 117)
                    .padding(.top, 112)

                Button(action: onResetButtonTap) {
                    Text(buttonTitle)
                        .font(.pretendard.head3)
                        .foregroundStyle(Color.white)
                        .frame(width: 174, height: 45)
                        .background(Color.black)
                        .clipShape(Capsule())
                }
                .padding(.top, 104)
            }
            .frame(
                width: ArchiveReceiptCardLayout.width,
                height: ArchiveReceiptCardLayout.bodyHeight,
                alignment: .top
            )
            .background(Color.BG)

            EmptyReceiptEdge()
                .fill(Color.BG)
                .frame(height: ArchiveReceiptCardLayout.edgeHeight)
                .rotationEffect(.degrees(180))
        }
        .frame(width: ArchiveReceiptCardLayout.width)
    }
}

private extension ArchiveEmptyStateView {
    var titleGroup: some View {
        VStack(spacing: 2) {
            Text(title)
            Text(message)
        }
        .font(.custom("CasquareCode35-Regular", size: 16).weight(.semibold))
        .foregroundStyle(Color.black)
        .multilineTextAlignment(.center)
    }
    
    func particleChanger(_ word: String) -> String {
        guard let lastCharacter = word.last else {
            return "가"
        }

        let unicode = String(lastCharacter).unicodeScalars.first!.value

        // 한글 음절 여부 + 종성 여부 확인
        if (0xAC00...0xD7A3).contains(unicode) {
            let hasFinalConsonant = (unicode - 0xAC00) % 28 != 0
            return hasFinalConsonant ? "이" : "가"
        }

        return "가"
    }

    var title: String {
        switch style {
        case .noReceipts:
            return "등록된 옷이 없어요!"

        case .noCategoryReceipts(let category):
            return "등록된 \(category)\(particleChanger(category)) 없어요!"

        case .noResults:
            return "조건에 맞는 옷이 없어요!"

        case .loadFailed(let message):
            return message
        }
    }

    var message: String {
        switch style {
        case .noReceipts, .noCategoryReceipts:
            return "옷을 등록해주세요"

        case .noResults:
            return "다른 조건으로 찾아주세요"

        case .loadFailed:
            return "잠시 후 다시 시도해주세요"
        }
    }

    var buttonTitle: String {
        switch style {
        case .noReceipts, .noCategoryReceipts:
            return "옷 등록"
        case .noResults:
            return "전체 보기"
        case .loadFailed:
            return "다시 시도"
        }
    }
}

private struct EmptyReceiptEdge: Shape {
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

#Preview("No Receipts") {
    ArchiveEmptyStateView(
        style: .noReceipts,
        onResetButtonTap: {}
    )
    .background {
        Image("ArchiveBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview("No Results") {
    ArchiveEmptyStateView(
        style: .noResults,
        onResetButtonTap: {}
    )
    .background {
        Image("ArchiveBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
