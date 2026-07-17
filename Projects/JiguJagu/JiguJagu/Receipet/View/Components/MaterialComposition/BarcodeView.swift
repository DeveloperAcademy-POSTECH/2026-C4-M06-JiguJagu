//
//  BarcordView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/16/26.
//

import SwiftUI

struct BarcodeView: View {
    
    let materials: [Material]
    private let pattern = "535552853555383555386245523432525243564"
    
    var body: some View {
        
        HStack(
            alignment: .center,
            spacing: 3
        ) {
            ForEach(
                Array(pattern).indices,
                id: \.self
            ) { index in
                
                let value =
                Int(
                    String(
                        Array(pattern)[index]
                    )
                ) ?? 1
                
                Rectangle()
                    .fill(colorFor(index: index))
                    .frame(
                        width: CGFloat(value),
                        height: 28
                    )
            }
        }
        .padding(0)
        .frame(
            width: 282,
            alignment: .leading
        )
    }
    
    private func colorFor(
        index: Int
    ) -> Color {
        
        let material = materialAt(index: index)
        
        switch material.name {
            
        case "Acrylic":
            return Color("ReceiptBrown")
            
        case "Polyester":
            return Color("ReceiptLightBrown")
            
        case "Wool":
            return Color("ReceiptOlive")
            
        case "Nylon":
            return Color("ReceiptOrange")
            
        default:
            return .black
        }
    }
    
    private func materialAt(
        index: Int
    ) -> Material {
        
        let totalWidth =
        pattern.reduce(0) { result, char in
            result + (Int(String(char)) ?? 1)
        }
        
        let currentWidth =
        pattern
            .prefix(index + 1)
            .reduce(0) { result, char in
                result + (Int(String(char)) ?? 1)
            }
        
        let ratio = Double(currentWidth) / Double(totalWidth)
        
        var accumulated = 0.0
        
        for material in materials {
            accumulated +=
            Double(material.percentage) / 100
            if ratio <= accumulated {
                return material
            }
        }
        
        return materials.last
        ??
        Material(
            name: "Unknown",
            percentage: 0
        )
    }
}
