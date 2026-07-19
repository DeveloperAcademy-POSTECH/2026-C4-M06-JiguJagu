//
//  FooterSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/15/26.
//

import SwiftUI

struct FooterSection: View {
    let date: String
    let category: String
    let tag: String
    
    init(
        date: String,
        category: String,
        tag: String
    ) {
        self.date = date
        self.category = category
        self.tag = tag
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Date : \(date)")
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown700)
            
            Text("Category : \(category)")
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown700)
            
            Text("Tag : \(tag)")
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown700)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FooterSection(date: "28-July-2026", category: "상의 > 니트", tag: "#니트 #파랑 #줄무늬")
        .padding()
}
