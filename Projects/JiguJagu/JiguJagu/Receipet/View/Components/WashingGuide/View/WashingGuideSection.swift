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
                .font(.title3.bold())
            
            ForEach(guides) { guide in
                
                HStack(alignment: .top, spacing: 16) {
                    
                    Image(guide.washingIcon)
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    Text(guide.washingDescription)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WashingGuideSection(
        guides: [
            WashingGuide(
                washingIcon: "wash",
                washingDescription: "30°C 이하 손세탁"
            ),
            WashingGuide(
                washingIcon: "bleach",
                washingDescription: "표백제 사용 금지"
            ),
            WashingGuide(
                washingIcon: "iron",
                washingDescription: "저온 다림질"
            ),
            WashingGuide(
                washingIcon: "dry",
                washingDescription: "자연 건조"
            )
        ]
    )
    .padding()
}
