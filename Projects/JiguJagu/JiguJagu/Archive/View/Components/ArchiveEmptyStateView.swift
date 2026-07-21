//
//  ArchiveEmptyStateView.swift
//  JiguJagu
//
//

import SwiftUI

struct ArchiveEmptyStateView: View {
    let hasActiveFilter: Bool
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

    var title: String {
        hasActiveFilter ? "조건에 맞는 옷이 없어요!" : "등록된 옷이 없어요!"
    }

    var message: String {
        hasActiveFilter ? "다른 조건으로 찾아주세요" : "옷을 등록해주세요"
    }

    var buttonTitle: String {
        hasActiveFilter ? "전체 보기" : "옷 등록"
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
        hasActiveFilter: false,
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
        hasActiveFilter: true,
        onResetButtonTap: {}
    )
    .background {
        Image("ArchiveBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
