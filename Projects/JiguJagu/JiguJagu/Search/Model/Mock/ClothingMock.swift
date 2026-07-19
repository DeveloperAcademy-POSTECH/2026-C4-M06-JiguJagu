//
//  ClothingMock.swift
//  JiguJagu
//
//  Created by 채유성 on 7/19/26.
//

#if DEBUG

import Foundation

extension Clothing {
    
    static let mocks: [Clothing] = [
        Clothing(
            brand: "CHICKS",
            productName: "브러쉬드 더블 스트라이프 카라 니트",
            productImageURL: nil
        ),
        Clothing(
            brand: "ZARA",
            productName: "단가라 반팔 카라 티셔츠",
            productImageURL: nil
        ),
        Clothing(
            brand: "H&M",
            productName: "브라운 줄무늬 긴팔 니트",
            productImageURL: nil
        ),
        Clothing(
            brand: "MANGO",
            productName: "배색 긴팔 카라 티셔츠",
            productImageURL: nil
        ),
        Clothing(
            brand: "UNIQLO",
            productName: "코튼 스트라이프 티셔츠",
            productImageURL: nil
        ),
        Clothing(
            brand: "UNIQLO",
            productName: "코튼 스트라이프 티셔츠",
            productImageURL: nil
        )
    ]
}

#endif
