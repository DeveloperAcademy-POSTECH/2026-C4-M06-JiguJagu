//
//  LoadingIllustrationView.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import SwiftUI

struct LoadingIllustrationView: View {
    var body: some View {
        ZStack {
            Image("LoadingOrbitSecondary")
                .resizable()
                .scaledToFit()
                .frame(width: 196, height: 136)
                .rotationEffect(.degrees(-2))
                .offset(x: 8, y: 4)

            Image("LoadingOrbitPrimary")
                .resizable()
                .scaledToFit()
                .frame(width: 215, height: 131)
                .rotationEffect(.degrees(-2))
                .offset(x: 4, y: 2)

            Image("LoadingEarthIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 78, height: 76)
                .offset(x: 0, y: 7)

            Image("LoadingShirtIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 34)
                .rotationEffect(.degrees(-14))
                .offset(x: -71, y: -46)

            Image("LoadingMagnifierIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 27, height: 38)
                .rotationEffect(.degrees(15))
                .offset(x: 79, y: 47)
        }
        .frame(width: 247, height: 205)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("의류 검색 로딩 일러스트")
    }
}

#Preview {
    LoadingIllustrationView()
        .padding()
        .background(Color.white)
}
