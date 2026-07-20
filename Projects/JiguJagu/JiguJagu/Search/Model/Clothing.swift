//
//  Clothing.swift
//  JiguJagu
//
//  Created by 채유성 on 7/18/26.
//

import Foundation

struct Clothing: Identifiable {
    let id = UUID()
    let brand: String
    let productName: String
    let productImageURL: URL?
}
