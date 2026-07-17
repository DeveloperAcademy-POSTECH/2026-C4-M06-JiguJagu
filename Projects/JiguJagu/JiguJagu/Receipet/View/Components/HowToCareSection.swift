//
//  HowToCareSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI

struct HowToCareSection: View {
    
    let careTips: [String]
    var body: some View {
        
        VStack(spacing: 14) {
            Text("How to care")
                .font(.title3.bold())
            
            ForEach(Array(careTips.enumerated()), id: \.offset) { index, tip in
                Text("\(index + 1). \(tip)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HowToCareSection(
        careTips: [
            "접어서 보관하세요.",
            "습기가 없는 곳에 보관하세요."
        ]
    )
}
