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
    let brandImage: String?
    let brandName: String

    enum CodingKeys: String, CodingKey {
        case cart, address
        case brandImage = "brand_image"
        case brandName = "brand_name"
    }
}
