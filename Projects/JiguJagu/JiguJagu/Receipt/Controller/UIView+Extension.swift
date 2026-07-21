//
//  UIView+Extension.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

import UIKit

extension UIView {
    
    func findScrollView() -> UIScrollView? {
        if let scrollView = self as? UIScrollView {
            return scrollView
        }
        
        for subview in subviews {
            if let scrollView = subview.findScrollView() {
                return scrollView
            }
        }
        
        return nil
    }
}
