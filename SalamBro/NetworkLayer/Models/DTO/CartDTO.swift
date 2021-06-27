//
//  CartDTO.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

struct CartDTO: Codable {
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case items = "positions"
    }

    struct Item: Codable, Equatable {
        var positionUUID: String
        var count: Int
        var comment: String
        var position: Position
        var modifiers: [Modifier]

        enum CodingKeys: String, CodingKey {
            case count, comment, position, modifiers
            case positionUUID = "position_uuid"
        }

        struct Position: Codable, Equatable {
            var name: String
            var image: String
            var description: String
            var price: Double
            var category: String

            static func == (lhs: Self, rhs: Self) -> Bool {
                return lhs.name == rhs.name &&
                    lhs.image == rhs.image &&
                    lhs.price == rhs.price &&
                    lhs.category == rhs.category
            }
        }

        struct Modifier: Codable, Equatable {
            var position: Position
            var positionUUID: String
            var count: Int

            enum CodingKeys: String, CodingKey {
                case position, count
                case positionUUID = "position_uuid"
            }

            static func == (lhs: Self, rhs: Self) -> Bool {
                return lhs.position == rhs.position &&
                    lhs.positionUUID == rhs.positionUUID
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.positionUUID == rhs.positionUUID &&
                lhs.comment == rhs.comment &&
                lhs.position == rhs.position &&
                lhs.modifiers == rhs.modifiers
        }
    }
}
