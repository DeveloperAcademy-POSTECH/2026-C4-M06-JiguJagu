//
//  ReceiptShareController.swift
//  JiguJagu
//
//  Created by 채유성 on 7/22/26.
//

import SwiftUI
import UIKit
import Combine

@MainActor
final class ReceiptShareController: ObservableObject {
    
    @Published var shareImage: Data?
    
    func makeShareImage<Content: View>(
        from view: Content,
        size: CGSize,
        scale: CGFloat = 3.0
    ) {
        let renderer = ImageRenderer(content: view)
        
        renderer.proposedSize = ProposedViewSize(size)
        renderer.scale = scale
        
        shareImage = renderer.uiImage?.pngData()
    }
    
    func clear() {
        shareImage = nil
    }
}
