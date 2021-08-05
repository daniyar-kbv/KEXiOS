//
//  Cart.swift
//  SalamBro
//
//  Created by Dan on 7/7/21.
//

import Foundation

struct Cart: Codable {
    var items: [CartItem]

    enum CodingKeys: String, CodingKey {
        case items = "positions"
    }
}

extension Cart {
    func getTotalPrice() -> Double {
        return items.map { Double($0.count) * ($0.position.price ?? 0) }.reduce(0, +)
    }
}

struct CartItem: Codable, Equatable {
    var count: Int
    var comment: String
    var position: CartPosition
    var modifierGroups: [CartModifierGroup]

    enum CodingKeys: String, CodingKey {
        case count, comment, position
        case modifierGroups = "modifier_groups"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.comment == rhs.comment &&
            lhs.position == rhs.position &&
            lhs.modifierGroups == rhs.modifierGroups
    }
}

extension CartItem {
    func getNumericPrice() -> Double {
        return (position.price ?? 0) * Double(count)
    }
}

struct CartPosition: Codable, Equatable {
    var uuid: String
    var name: String
    var image: String?
    var price: Double?
    var categoryUUID: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, image, price
        case categoryUUID = "category"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct CartModifierGroup: Codable, Equatable {
    let uuid: String
    var modifiers: [CartModifier]

    enum CodingKeys: String, CodingKey {
        case modifiers
        case uuid = "modifier_group"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid &&
            lhs.modifiers == rhs.modifiers
    }
}

struct CartModifier: Codable, Equatable {
    var position: CartPosition
    var count: Int

    enum CodingKeys: String, CodingKey {
        case position, count
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.position == rhs.position
    }
}

extension Cart {
    func toDTO() -> CartDTO {
        return .init(items: items.map { item in
            .init(
                positionUUID: item.position.uuid,
                count: item.count,
                comment: item.comment,
                modifierGroups: item.modifierGroups.map { modifierGroup in
                    .init(
                        uuid: modifierGroup.uuid,
                        modifiers: modifierGroup.modifiers.map { modifier in
                            .init(
                                positionUUID: modifier.position.uuid,
                                count: modifier.count
                            )
                        }
                    )
                }
            )
        })
    }
}
