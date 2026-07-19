//
//  ClothingCard.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct ClothingCard: View {
    
    let item: Clothing
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            AsyncImage(url: item.productImageURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.1)
            }
            .scaledToFit()
            .frame(width: 180, height: 182)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        Color.gray.opacity(0.3),
                        lineWidth: 1
                    )
            )
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(item.brand)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(item.productName)
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            
        }
        .frame(width: 180, height: 239)
    }
}
