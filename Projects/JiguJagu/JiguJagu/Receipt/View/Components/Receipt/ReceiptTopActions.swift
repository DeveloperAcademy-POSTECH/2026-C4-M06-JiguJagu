//
//  ReceiptTopActions.swift
//  JiguJagu
//
//  Created by 채유성 on 7/20/26.
//

import SwiftUI
import UIKit

struct ReceiptTopActions: View {
    
    let shareImage: Data?
    var onClose: () -> Void = {
        NotificationCenter.default.post(name: .goHome, object: nil)
    }
    var onArchive: () -> Void = {}

    @State private var showShare = false
    
    var body: some View {
        HStack {
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)
            .padding(.leading, -4)
            
            Spacer()
            
            HStack(spacing: 10) {
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 24, height: 24)
                .sheet(isPresented: $showShare) {
                    if let shareImage {
                        ActivityView(activityItems: [shareImage])
                    }
                }
                
                Button {
                    onArchive()
                } label: {
                    Image(systemName: "folder")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 24, height: 24)
            }
            .frame(width: 76, height: 44)
        }
        .frame(width: 370, height: 44)
    }
}

#Preview {
    ReceiptTopActions(
        shareImage: nil
    )
}
