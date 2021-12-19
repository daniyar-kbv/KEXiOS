//
//  CartDTO.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

struct CartDTO: Encodable {
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case items = "positions"
    }

    struct Item: Encodable {
        let positionUUID: String
        let count: Int
        let comment: String?
        let modifiers: [Modifier]

        enum CodingKeys: String, CodingKey {
            case count, comment, modifiers
            case positionUUID = "position"
        }

        struct Modifier: Encodable {
            let modifierGroupUUID: String?
            let positionUUID: String
            let count: Int

            enum CodingKeys: String, CodingKey {
                case modifierGroupUUID = "modifier_group"
                case count
                case positionUUID = "position"
            }
        }
    }
}
