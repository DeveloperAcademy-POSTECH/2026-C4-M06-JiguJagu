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

        VStack(alignment: .leading, spacing: 10) {
            Text("Material Composition")
                .font(.title3.bold())
            BarcodeView(
                materials: materials
            )
            
            ForEach(
                materials,
                id: \.name
            ) { material in
                HStack {
                    Text(material.name)
                    
                    Spacer()
                    
                    Text("\(material.percentage)%")
                }
            }
            .padding(.top, 20)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
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
