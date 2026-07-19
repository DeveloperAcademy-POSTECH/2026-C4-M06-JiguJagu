//
//  InfoSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI

struct InfoSection: View {
    
    let category: String
    let brandName: String
    let productName: String
    let productImageURL: String?
    
    var body: some View {
        
        VStack(spacing: 10) {
            Text(category)
                .font(Font.arrayFont.sub1)
            VStack {
                Text(brandName)
                    .font(Font.pretendard.head4)
                Text(productName)
                    .font(Font.pretendard.head4)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            
            if let productImageURL = productImageURL,
               let url = URL(string: productImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                Gradient.Clothes
                            }
                    case .failure:
                        Image("MockProduct")
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                Gradient.Clothes
                            }
                    @unknown default:
                        Image("MockProduct")
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                Gradient.Clothes
                            }
                        
                    }
                }
                .frame(height: 220)
            } else {
                Image("MockProduct")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        Gradient.Clothes
                    }
                    .frame(height: 220)
            }
        }
    }
}

extension Gradient {
    static var Clothes: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(
                    color: Color(red: 0.95, green: 0.95, blue: 0.93).opacity(0),
                    location: 0.00
                ),
                Gradient.Stop(
                    color: Color(red: 0.95, green: 0.95, blue: 0.93),
                    location: 1.00
                )
            ],
            startPoint: UnitPoint(x: 0.5, y: 0.5),
            endPoint: UnitPoint(x: 0.5, y: 0.84)
        )
    }
}

#Preview {
    InfoSection(
        category: "[ 상의 > 니트 ]",
        brandName: "CHICKS",
        productName: "더블 스트라이프 카라 니트",
        productImageURL: nil
    )
}
