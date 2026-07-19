//
//  WashingGuideSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI

struct WashingGuideSection: View {
    
    let guides: [WashingGuide]
    var body: some View {
        
        VStack(spacing: 14) {
            
            Text("Washing Guide")
                .font(Font.arrayFont.h0)
            
            ForEach(guides , id: \.id) { guide in
                
                HStack(alignment: .top, spacing: 16) {
                    
                    Image(guide.washingIcon)
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    Text(guide.washingDescription)
                        .frame(width: 206, height: 60, alignment: .leading)
                        .font(Font.pretendard.body3)
                        .foregroundStyle(Color.brown700)
                        .lineSpacing(4)
                }
                .frame(width: 280, height: 60)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WashingGuideSection(
        guides: [
            WashingGuide(
                id: "handwash",
                washingIcon: "wash",
                washingDescription: "30°C 이하 손세탁"
            ),
            WashingGuide(
                id: "bleach",
                washingIcon: "bleach",
                washingDescription: "표백제 사용 금지"
            ),
            WashingGuide(
                id: "iron",
                washingIcon: "iron",
                washingDescription: "저온 다림질"
            ),
            WashingGuide(
                id: "dry",
                washingIcon: "dry",
                washingDescription: "자연 건조"
            )
        ]
    )
    .padding()
}
