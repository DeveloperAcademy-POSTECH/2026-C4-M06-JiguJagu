//
//  Receipt.swift
//  JiguJagu
//
//  Created by 채유성 on 7/20/26.
//

import Foundation

struct Receipt {
    let clothing: Clothing
    let howToCare: [HowToCare]
    let washingGuides: [WashingGuide]
    let materials: [Material]
    let createdAt: Date
}
