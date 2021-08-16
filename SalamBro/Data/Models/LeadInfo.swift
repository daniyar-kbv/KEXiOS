//
//  AddressInfo.swift
//  SalamBro
//
//  Created by Dan on 8/13/21.
//

import Foundation

struct LeadInfo: Decodable {
    let cart: Cart
    let address: Address
    let brandImage: String
    let brandName: String
    let price: Double
    let positionsCount: Int

    enum CodingKeys: String, CodingKey {
        case cart, address, price
        case brandImage = "brand_image"
        case brandName = "brand_name"
        case positionsCount = "positions_count"
    }
}
