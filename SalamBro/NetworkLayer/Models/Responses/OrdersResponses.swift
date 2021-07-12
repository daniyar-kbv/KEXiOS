//
//  OrdersResponses.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation

struct OrderApplyResponse: Codable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Codable {
        let uuid: String
        let localBrand: Int

        enum CodingKeys: String, CodingKey {
            case uuid
            case localBrand = "local_brand"
        }
    }
}

struct OrderProductResponse: Codable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Codable {
        let uuid: String
        let categories: [MenuCategory]
        let positions: [MenuPosition]
    }
}

struct OrderProductDetailResponse: Codable {
    let data: MenuPositionDetail?
    let error: ErrorResponse?
}

struct OrderUpdateCartResponse: Codable {
    let data: Cart?
    let error: ErrorResponse?
}
