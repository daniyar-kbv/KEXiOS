//
//  OrdersResponses.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation

struct OrdersListResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [OrdersList]

        enum CodingKeys: String, CodingKey {
            case count, next, previous, results
        }
    }
}

struct OrderApplyResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {
        let uuid: String

        enum CodingKeys: String, CodingKey {
            case uuid
        }
    }
}

struct OrderProductResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {
        let uuid: String
        let categories: [MenuCategory]
    }
}

struct OrderProductDetailResponse: Decodable {
    let data: MenuPositionDetail?
    let error: ErrorResponse?
}

struct AdditionalNomenclatureResponse: Decodable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Decodable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [AdditionalPosition]
    }
}

struct OrderUpdateCartResponse: Decodable {
    let data: Cart?
    let error: ErrorResponse?
}

struct OrdersShowResponse: Decodable {
    let data: LeadInfo?
    let error: ErrorResponse?
}
