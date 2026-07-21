//
//  TopGradientOverlay.swift
//  JiguJagu
//
//  Created by SIA on 7/21/26.
//

import SwiftUI

struct TopGradientOverlay: View {
    
    var body: some View {
        LinearGradient(
            colors: [
                .clear,
                .primary500.opacity(0.8)
            ],
            startPoint: .bottom,
            endPoint: .top
        )
        .frame(height: 466)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .top)
        .allowsHitTesting(false)
    }
}
