//
//  BottomGradientOverlay.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import SwiftUI

struct BottomGradientOverlay: View {
    
    var body: some View {
        LinearGradient(
            colors: [
                .clear,
                .gray.opacity(0.8)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 161)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .allowsHitTesting(false)
    }
}
