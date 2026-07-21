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
                .font(Font.arrayFont.h0)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ForEach(Array(careTips.enumerated()), id: \.offset) { index, tip in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(index + 1)")
                        .font(Font.pretendard.body1)
                        .foregroundStyle(Color.brown700)
                        .frame(width: 12, alignment: .leading)
                    
                    Text(tip)
                        .font(Font.pretendard.body3)
                        .foregroundStyle(Color.brown700)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: 280, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
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
