//
//  LoadingProgressBar.swift
//  JiguJagu
//
//  Created by mason on 7/21/26.
//

import SwiftUI

struct LoadingProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: geometry.size.height / 2)
                .fill(Color.white)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .fill(Color.green500)
                        .frame(width: fillWidth(totalWidth: geometry.size.width))
                }
        }
        .frame(height: 10)
        .accessibilityElement(children: .ignore)
    }
}

private extension LoadingProgressBar {
    func fillWidth(totalWidth: CGFloat) -> CGFloat {
        totalWidth * min(max(progress, 0), 1)
    }
}

#Preview {
    LoadingProgressBar(progress: 0.2)
        .frame(width: 247, height: 10)
        .padding()
        .background(Color.grayScale200)
}
