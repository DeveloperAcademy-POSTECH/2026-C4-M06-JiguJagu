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
                .font(.title3.bold())
            
            VStack(spacing: 12) {
                
                BarcodeView(
                    materials: materials
                )
                
                let maxPercentage = materials.max(by: { $0.percentage < $1.percentage })?.percentage ?? 0
                
                ForEach(materials, id: \.name) { material in

                    HStack {
                        Text(material.name)
                            .fontWeight(material.percentage == maxPercentage ? .bold : .regular)
                        
                        Spacer()

                        Text("\(material.percentage)%")

                            .fontWeight(material.percentage == maxPercentage ? .bold : .regular)
                    }
                    .frame(maxWidth: .infinity)
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
