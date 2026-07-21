//
//  NaverShoppingResponseDTO.swift
//  JiguJagu
//
//  Created by 채유성 on 7/21/26.
//

struct NaverShoppingResponseDTO: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [NaverShoppingItem]
}
