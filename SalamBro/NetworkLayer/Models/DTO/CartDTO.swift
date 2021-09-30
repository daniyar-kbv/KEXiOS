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
        let modifierGroups: [ModifierGroup]

        enum CodingKeys: String, CodingKey {
            case count, comment
            case positionUUID = "position"
            case modifierGroups = "modifiers"
        }

        struct ModifierGroup: Encodable {
            let uuid: String?
            let positionUUID: String
            let count: Int

            enum CodingKeys: String, CodingKey {
                case uuid = "modifier_group"
                case count
                case positionUUID = "position"
            }
        }
    }
}
