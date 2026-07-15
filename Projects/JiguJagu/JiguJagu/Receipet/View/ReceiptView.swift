//
//  ReceiptView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//
import SwiftUI

struct ReceiptView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                VStack(spacing: 6) {
                    Text("Logo")
                        .font(.title.bold())
                    Text("GOOD FOR EARTH • GOOD FOR ENVIRONMENT")
                        .font(.caption)
                }
                .padding(.top, 20)
                
                InfoSection(
                    category: "[ 상의 > 니트 ]", productName: "칙스 브러쉬드 더블 스트라이프 카라 니트"
                )
                
                Divider()
                
                HowToCareSection(
                    careTips: [
                        "접어서 보관하세요.",
                        "습기가 없는 곳에 보관하세요."
                    ]
                )
                
                Divider()
                
                WashingGuideSection(
                    guides: [
                        "30°C 이하 손세탁",
                        "표백제 사용 금지",
                        "저온 다림질",
                        "자연 건조"
                    ]
                )
                
                Divider()
                
                MaterialCompositionSection(
                    materials: [
                        Material(name: "Acrylic", percentage: 60),
                        Material(name: "Polyester", percentage: 20),
                        Material(name: "Wool", percentage: 15),
                        Material(name: "Nylon", percentage: 5)
                    ]
                )
                
                Divider()
                
                FooterSection()
            }
            .padding()
            .frame(width: 306)
            .background(Color.white)
            .padding(.vertical)
        }
    }
}

#Preview {
    ReceiptView()
}
