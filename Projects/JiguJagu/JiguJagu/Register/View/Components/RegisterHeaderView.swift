//
//  RegisterHeaderView.swift
//  JiguJagu
//
//  Created by 채유성 on 7/21/26.
//

import SwiftUI

struct RegisterHeaderView: View {
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(Color.grayScale900)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("뒤로가기")
            
            Spacer()
            
            Image("BrownLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 108, height: 28)
                .accessibilityLabel("오래입자구")
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.top, Layout.headerTopPadding)
    }
}

private enum Layout {
    static let horizontalPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 12
}

#Preview {
    RegisterHeaderView {
        print("뒤로가기")
    }
}
