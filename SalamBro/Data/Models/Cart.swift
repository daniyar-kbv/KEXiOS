//
//  Cart.swift
//  SalamBro
//
//  Created by Dan on 7/7/21.
//

import Foundation

struct Cart: Codable {
    var totalPrice: Double
    var deliveryPrice: Double
    var positionsPrice: Double
    var positionsCount: Int
    var items: [CartItem]
    var minPrice: Double
    var hasUnavailableProducts: Bool

    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case deliveryPrice = "delivery_price"
        case positionsPrice = "positions_price"
        case positionsCount = "positions_count"
        case items = "positions"
        case minPrice = "min_price"
        case hasUnavailableProducts = "has_unavailable_positions"
    }
}

extension Cart {
    func getBadgeCount() -> String? {
        return positionsCount == 0 ? nil : String(positionsCount)
    }

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

class CartItem: Codable {
    let internalUUID: String = UUID().uuidString
    var count: Int
    var comment: String?
    var position: CartPosition
    var modifierGroups: [CartModifierGroup]

    enum CodingKeys: String, CodingKey {
        case count, comment, position
        case modifierGroups = "modifier_groups"
    }

    init(count: Int, comment: String?, position: CartPosition, modifierGroups: [CartModifierGroup]) {
        self.count = count
        self.comment = comment
        self.position = position
        self.modifierGroups = modifierGroups
    }
}

extension CartItem: Equatable {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
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
    var positionType: String
    var isAvailable: Bool
    var description: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, image, price, description
        case positionType = "position_type"
        case isAvailable = "is_available"
    }

    enum PositionType: String, Codable {
        case main = "MAIN"
        case modifier = "MODIFIER"
        case additional = "ADDITIONAL"
        case dayDelivery = "DAY_DELIVERY"
        case nightDelivery = "NIGHT_DELIVERY"
    }

    func getPositionType() -> PositionType? {
        return PositionType(rawValue: positionType)
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
