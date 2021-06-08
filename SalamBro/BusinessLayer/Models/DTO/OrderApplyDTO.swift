//
//  OrderApplyDTO.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation

struct OrderApplyDTO: Encodable {
    let brandId: Int
    let cityId: Int
    let address: Address

    struct Address: Encodable {
        let longitude: String
        let latitude: String
    }

    enum CodingKeys: String, CodingKey {
        case brandId = "brand_id"
        case cityId = "city_id"
        case address
    }
}

struct OrderIncDecrDTO: Encodable {
    let leadUUID: String
    let positionUUID: String

    enum CodingKeys: String, CodingKey {
        case leadUUID = "lead_uuid"
        case positionUUID = "position_ uuid"
    }
}
