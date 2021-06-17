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
        let city: Int
        let longitude: Double
        let latitude: Double
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
