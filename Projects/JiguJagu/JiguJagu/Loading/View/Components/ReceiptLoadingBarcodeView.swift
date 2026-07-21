//
//  ReceiptLoadingBarcodeView.swift
//  JiguJagu
//
//  Created by mason on 7/22/26.
//

import SwiftUI

struct ReceiptLoadingBarcodeView: View {
    var body: some View {
        HStack(alignment: .center, spacing: Metric.lineSpacing) {
            ForEach(ReceiptLoadingBarcodePattern.lines) { line in
                Rectangle()
                    .fill(Color.grayScale900)
                    .frame(width: line.width)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .accessibilityHidden(true)
    }
}

private struct ReceiptLoadingBarcodeLine: Identifiable {
    let id: Int
    let width: CGFloat
}

private enum ReceiptLoadingBarcodePattern {
    static let lines: [ReceiptLoadingBarcodeLine] = encodedWidths.enumerated().map {
        ReceiptLoadingBarcodeLine(id: $0.offset, width: width(for: $0.element))
    }

    private static let encodedWidths = "23211232123121222132322123212312232"

    private static func width(for code: Character) -> CGFloat {
        switch code {
        case "1":
            return Metric.thin
        case "2":
            return Metric.regular
        case "3":
            return Metric.medium
        default:
            return Metric.regular
        }
    }
}

private enum Metric {
    static let thin: CGFloat = 0.5
    static let regular: CGFloat = 1
    static let medium: CGFloat = 1.8
    static let lineSpacing: CGFloat = 1.35
}

#Preview {
    ReceiptLoadingBarcodeView()
        .frame(width: 97.57, height: 18.23)
        .padding()
        .background(Color.white)
}
