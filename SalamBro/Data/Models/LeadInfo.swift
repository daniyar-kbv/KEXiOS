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

    enum CodingKeys: String, CodingKey {
        case cart, address
        case brandImage = "brand_image"
        case brandName = "brand_name"
    }

    struct Address: Decodable {
        let city: Int
        let longitude: Double
        let latitude: Double
        let district: String?
        let street: String?
        let building: String?
        let corpus: String?
        let flat: String?
        let comment: String?
    }
}

extension LeadInfo.Address {
    func toAddress() -> Address {
        return .init(district: district, street: street, building: building, corpus: corpus, flat: flat, comment: comment, country: nil, city: nil, longitude: longitude, latitude: latitude)
    }
}
