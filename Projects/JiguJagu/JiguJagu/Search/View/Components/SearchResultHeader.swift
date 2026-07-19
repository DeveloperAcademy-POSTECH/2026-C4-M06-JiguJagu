//
//  SearchResultHeader.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct SearchResultHeader: View {
    
    let count: Int
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            HStack(spacing: 8) {
                
                Text("등록할 내 옷 찾기")
                    .font(.headline)
                
                Text("\(count) results")
                    .foregroundStyle(.secondary)
                
            }
            
            Spacer()
            
            Button(action: action) {
                
                HStack(spacing: 4) {
                    Text("옷 자체 등록")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.weight(.semibold))
                
            }
        }
    }
}
