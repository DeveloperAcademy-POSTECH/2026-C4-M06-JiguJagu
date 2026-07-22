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
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            HStack(spacing: 14) {
                Button {
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                }
                .sheet(isPresented: $showShare) {
                    if let shareImage {
                        ActivityView(activityItems: [shareImage])
                    }
                }
                
                Button {
                    onArchive()
                } label: {
                    Image(systemName: "folder")
                        .font(.system(size: 23, weight: .medium))
                        .foregroundStyle(.white)
                        .offset(y: 3.5)
                }
            }
            .offset(x: -5)
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
