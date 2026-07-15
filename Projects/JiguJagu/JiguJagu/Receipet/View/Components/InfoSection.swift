//
//  InfoSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI

struct InfoSection: View {
    
    let category: String
    let productName: String
    
    var body: some View {
        
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(category)
                    .font(.headline)
                Text(productName)
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 이미지 영역 (임시로 사각형)
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.2))
                .frame(height: 220)
        }
    }
}

#Preview {
    InfoSection(
        category: "[ 상의 > 니트 ]",
        productName: "칙스 브러쉬드 더블 스트라이프 카라 니트"
    )
}
