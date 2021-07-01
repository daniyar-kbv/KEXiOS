//
//  CartDTO.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

struct CartDTO: Codable {
    let items: [CartItem]

    enum CodingKeys: String, CodingKey {
        case items = "positions"
    }
}

struct CartItem: Codable, Equatable {
    var positionUUID: String
    var count: Int
    var comment: String
    var position: CartPosition
    var modifiers: [CartModifier]

    enum CodingKeys: String, CodingKey {
        case count, comment, position, modifiers
        case positionUUID = "position_uuid"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.positionUUID == rhs.positionUUID &&
            lhs.comment == rhs.comment &&
            lhs.position == rhs.position &&
            lhs.modifiers == rhs.modifiers
    }
}

struct CartPosition: Codable, Equatable {
    var uuid: String
    var name: String
    var image: String?
    var description: String?
    var price: Double?
    var categoryUUID: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, image, description, price
        case categoryUUID = "category"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct CartModifier: Codable, Equatable {
    var position: CartPosition
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
