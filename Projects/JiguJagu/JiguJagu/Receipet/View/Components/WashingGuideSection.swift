//
//  WashingGuideSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI

struct WashingGuideSection: View {

    let guides: [String]
    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            Text("Washing Guide")
                .font(.title3.bold())

            ForEach(guides, id: \.self) { guide in
                HStack(alignment: .top, spacing: 16) {
                    Circle()
                        .frame(width: 50, height: 50)
                    Text(guide)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    WashingGuideSection(
        guides: [
            "30°C 이하 손세탁",
            "표백제 사용 금지",
            "저온 다림질",
            "자연 건조"
        ]
    )
}
