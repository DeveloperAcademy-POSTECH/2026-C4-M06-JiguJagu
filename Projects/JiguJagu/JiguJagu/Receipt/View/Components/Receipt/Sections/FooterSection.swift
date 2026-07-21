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
    
    init(
        date: String,
        category: String,
    ) {
        self.date = date
        self.category = category
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Date : \(date)")
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown700)
            
            Text("Category : \(category)")
                .font(.pretendard.body3)
                .foregroundStyle(Color.brown700)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FooterSection(date: "28-July-2026", category: "상의 > 니트")
        .padding()
}
