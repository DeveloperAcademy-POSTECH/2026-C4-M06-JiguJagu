//
//  FloatingUpButton.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import SwiftUI

struct FloatingUpButton: View {
    
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            Image(systemName: "arrow.up")
                .font(.system(size: 24))
                .frame(width: 54, height: 54)
                .background(.white)
                .foregroundStyle(Color.black)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .inset(by: 0.5)
                        .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                )
            
        }
    }
}
