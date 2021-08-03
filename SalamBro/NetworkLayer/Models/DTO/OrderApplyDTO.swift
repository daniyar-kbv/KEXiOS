//
//  OrderApplyDTO.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation

struct OrderApplyDTO: Encodable {
    let address: Address
    let localBrand: Int

    enum CodingKeys: String, CodingKey {
        case address
        case localBrand = "local_brand"
    }

    struct Address: Encodable {
        var district: String?
        var street: String?
        var building: String?
        var corpus: String?
        var flat: String?
        var comment: String?
        var country: Int
        var city: Int
        var longitude: Double
        var latitude: Double
    }
}
