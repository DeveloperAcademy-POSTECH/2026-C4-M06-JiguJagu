//
//  ClothingMapper.swift
//  JiguJagu
//
//  Created by 채유성 on 7/21/26.
//

import Foundation

extension Clothing {

    init(from item: NaverShoppingItem) {
        self.brand = item.brand
        self.productName = item.title.strippingHTML()

        self.mockImageName = nil
        self.productImageURL = URL(string: item.image)

        self.category3 = item.category3
        self.category4 = item.category4

        self.howToCare = []
        self.washingGuides = []
        self.materials = []
    }
}
