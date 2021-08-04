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

        enum CodingKeys: String, CodingKey {
            case uuid
        }
    }
}

struct OrderProductResponse: Codable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Codable {
        let uuid: String
        let categories: [MenuCategory]
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
