//
//  SearchResultSummary.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct SearchResultSummary: View {
    
    let count: Int
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            HStack(spacing: 8) {
                
                Text("등록할 내 옷 찾기")
                    .font(Font.pretendard.head2)
                
                Text("\(count) results")
                    .font(Font.pretendard.head4)
                    .foregroundStyle(Color.grayScale300)
                
            }
            
            Spacer()
            
            Button(action: action) {
                
                HStack(spacing: 11) {
                    Text("직접 등록하기")
                        .font(Font.pretendard.body2)
                        .foregroundStyle(Color.primary500)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.primary500)
                }
                .font(.subheadline.weight(.semibold))
                
            }
        }
    }
}
