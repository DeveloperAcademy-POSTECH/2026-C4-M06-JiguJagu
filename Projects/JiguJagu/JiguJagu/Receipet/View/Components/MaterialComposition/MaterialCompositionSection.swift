//
//  MaterialCompositionSection.swift
//  JiguJagu
//
//  Created by 채유성 on 7/14/26.
//

import SwiftUI

struct MaterialCompositionSection: View {
    
    let materials: [Material]
    
    var body: some View {
        
        VStack(spacing: 14) {
            
            Text("Material Composition")
                .font(Font.arrayFont.h0)
            
            VStack(spacing: 12.53) {
                
                BarcodeView(
                    materials: materials
                )
                
                let maxPercentage = materials.max(by: { $0.percentage < $1.percentage })?.percentage ?? 0
                
                VStack(spacing: 4) {
                    ForEach(materials, id: \.name) { material in
                        
                        HStack {
                            Text(material.name)
                                .font(
                                    material.percentage == maxPercentage
                                    ? .pretendard.head4
                                    : .pretendard.body6
                                )
                            
                            Spacer()
                            
                            Text("\(material.percentage)%")
                                .font(
                                    material.percentage == maxPercentage
                                    ? .pretendard.head4
                                    : .pretendard.body6
                                )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    
    MaterialCompositionSection(
        materials: [
            Material(
                name: "Acrylic",
                percentage: 60
            ),
            Material(
                name: "Polyester",
                percentage: 20
            ),
            Material(
                name: "Wool",
                percentage: 15
            ),
            Material(
                name: "Nylon",
                percentage: 5
            )
        ]
    )
    .padding()
}
