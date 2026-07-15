//
//  FooterSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/15/26.
//

import SwiftUI

struct FooterSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Date : 28-July-2026")
            Text("Category : 상의 > 니트")
            Text("Tag : #니트 #파랑 #줄무늬")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FooterSection()
        .padding()
}
