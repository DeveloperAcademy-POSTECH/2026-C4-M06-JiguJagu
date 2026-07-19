//
//  DisableScrollBounce.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import UIKit
import SwiftUI

struct DisableScrollBounce: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        DispatchQueue.main.async {
            if let scrollView = view.findScrollView() {
                scrollView.bounces = false
                scrollView.alwaysBounceVertical = false
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}
