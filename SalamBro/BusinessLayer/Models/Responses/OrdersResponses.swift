//
//  OrdersResponses.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation

struct OrderApplyResponse: Codable {
    let uuid: String
    let brandId: Int
    let cityId: Int
    let address: Address

    struct Address: Codable {
        let id: Int
        let title: String
        let longitude: String
        let latitude: String
        let country: String
        let region: String
        let city: String
        let district: String
        let street: String
        let building: String
        let corpus: String
        let flat: String
        let postalCode: String

        enum CodingKeys: String, CodingKey {
            case id, title, longitude, latitude, country, region, city, district, street, building, corpus, flat
            case postalCode = "postal_code"
        }
    }
}

struct OrderIncrDecrResponse: Codable {}

struct OrderProductResponse: Codable {
    let uuid: String
    let categories: [Category]
    let positions: [Position]

    struct Category: Codable {
        let name: String
        let uuid: String
    }

    struct Position: Codable {
        let id: Int
        let name: String
        let description: String
        let image: String
        let price: Double
        let branchCategory: String

        enum CodingKeys: String, CodingKey {
            case id, name, description, image, price
            case branchCategory = "branch_category"
        }
    }
}

struct OrderUpdateCartResponse: Codable {}
