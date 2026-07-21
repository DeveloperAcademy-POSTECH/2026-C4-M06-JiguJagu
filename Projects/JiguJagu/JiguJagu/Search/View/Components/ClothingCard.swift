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
            
            productImage
                .frame(width: 180, height: 182)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color.grayScale200,
                            lineWidth: 1
                        )
                )
                .background(Color.grayScale100)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.brand)
                    .font(Font.pretendard.body2)
                    .foregroundStyle(Color.grayScale900)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(item.productName)
                    .font(Font.pretendard.body3)
                    .foregroundStyle(Color.grayScale900)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
        }
        .frame(width: 180, height: 239)
    }
}

private extension ClothingCard {
    
    @ViewBuilder
    private var productImage: some View {
        
        if let mockImageName = item.mockImageName {
            Image(mockImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 122, height: 121)
        } else if let url = item.productImageURL {
            
            AsyncImage(url: url) { phase in
                
                switch phase {
                case .empty:
                    ProgressView()
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                    
                default:
                    unavailableImage
                }
            }
        } else {
            unavailableImage
        }
    }
    
    private var unavailableImage: some View {
        
        Text("이미지를\n로드할 수 없습니다")
            .multilineTextAlignment(.center)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
    }
}
