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
        let categories: [Category]
        let positions: [Position]

        struct Category: Codable {
            let name: String
            let uuid: String
        }

        struct Position: Codable {
            let uuid: String
            let name: String
            let description: String
            let image: String?
            let price: Double
            let category: String
        }
    }
}

struct OrderProductDetailResponse: Codable {
    let data: Data?
    let error: ErrorResponse?

    struct Data: Codable {
        let uuid: String
        let name: String
        let description: String
        let image: String?
        let price: [Double]
        let branchCategory: String
//        let modifiers: [Modifier]

        enum CodingKeys: String, CodingKey {
            case uuid, name, description, image, price
//            case modifiers
            case branchCategory = "branch_category"
        }

        struct Modifier: Codable {
            let uuid: String
            let name: String
            let minAmount: Int
            let maxAmount: Int

            enum CodingKeys: String, CodingKey {
                case uuid, name
                case minAmount = "min_amount"
                case maxAmount = "max_amount"
            }
        }
    }
}
