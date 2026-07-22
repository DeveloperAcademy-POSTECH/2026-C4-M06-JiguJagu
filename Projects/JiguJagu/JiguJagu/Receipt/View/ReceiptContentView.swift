//
//  ReceiptContentView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/22/26.
//

import SwiftUI
import UIKit

struct ReceiptContentView: View {
    let clothing: Clothing
    let localImage: UIImage?
    let formatter: DateFormatter
    let registeredDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 24) {
                Image("BrownLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 99.8, height: 18.85)
                    .padding(.top, 20)
                
                VStack(spacing: 10.66) {
                    Image("StarDevider")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 291.78, height: 3.66)
                    
                    Text("GOOD FOR EARTH * GOOD FOR ENVIRONMENT")
                        .font(Font.arrayFont.sub2)
                    
                    Image("StarDevider")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 291.78, height: 3.66)
                }
                
                VStack(spacing: 3) {
                    InfoSection(
                        category: "[ \(clothing.category3) > \(clothing.category4) ]",
                        brandName: clothing.brand,
                        productName: clothing.productName,
                        productImageURL: clothing.productImageURL?.absoluteString,
                        mockImageName: clothing.mockImageName,
                        localImage: localImage
                    )
                    
                    HowToCareSection(
                        careTips: clothing.howToCare
                    )
                }
                
                Divider()
                    .background(Color.brown700)
                
                WashingGuideSection(
                    guides: clothing.washingGuides
                )
                
                Divider()
                    .background(Color.brown700)
                
                MaterialCompositionSection(
                    materials: clothing.materials
                )
                
                Divider()
                    .background(Color.brown700)
                
                FooterSection(
                    date: formatter.string(from: registeredDate),
                    category: "\(clothing.category3) > \(clothing.category4)"
                )
            }
            .padding(
                EdgeInsets(
                    top: 12,
                    leading: 12,
                    bottom: 20,
                    trailing: 12
                )
            )
            .frame(width: 306)
            .background(Color(Color.BG))
            
            
            Image("ReceiptBottom")
                .resizable()
                .renderingMode(.original)
                .frame(width: 306, height: 24)
        }
    }
}
