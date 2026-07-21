//
//  ReceiptLoadingIllustrationView.swift
//  JiguJagu
//
//  Created by mason on 7/22/26.
//

import SwiftUI

struct ReceiptLoadingIllustrationView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("ReceiptLoadingPrinter")
                .resizable()
                .frame(width: 156.6, height: 36)
                .offset(x: 0, y: 0)
                .zIndex(2)

            Image("ReceiptLoadingPaper")
                .resizable()
                .frame(width: 117, height: 163.8)
                .offset(x: 18.9, y: 16.2)
                .zIndex(1)

            Image("LoadingEarthIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 68.4, height: 66.6)
                .offset(x: 42.3, y: 45)
                .zIndex(2)

            Image("ReceiptLoadingTearLine")
                .resizable()
                .frame(width: 102.6, height: 0.5)
                .offset(x: 26.1, y: 135)
                .zIndex(2)

            ReceiptLoadingBarcodeView()
                .frame(width: 97.57, height: 18.23)
                .offset(x: 29.79, y: 146.67)
                .zIndex(2)
        }
        .frame(width: 180, height: 180)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("영수증이 출력되는 로딩 일러스트")
    }
}

#Preview {
    ReceiptLoadingIllustrationView()
        .padding()
        .background(Color.white)
}
