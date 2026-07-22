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
    let mockImageName: String? // TODO: Mock 이미지 로드를 위한 변수 (추후 삭제)
    var localImage: UIImage? = nil // 누끼 딴 로컬 이미지 (있으면 최우선 표시)
    
    @ViewBuilder
    private var mockImage: some View {
        if let mockImageName {
            Image(mockImageName)
                .resizable()
                .scaledToFit()
                .overlay {
                    Gradient.Clothes
                }
                .frame(height: 220)
        } else {
            Text("이미지를\n로드할 수 없습니다")
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .frame(height: 220)
        }
    }
    
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
            
            if let localImage {
                // 누끼 딴 로컬 이미지 최우선 표시
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        Gradient.Clothes
                    }
                    .frame(height: 220)
            } else if let productImageURL = productImageURL,
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
                        mockImage
                    @unknown default:
                        mockImage
                        
                    }
                }
                .frame(height: 220)
            } else {
                mockImage
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
        productImageURL: nil,
        mockImageName: "P1"
    )
}
