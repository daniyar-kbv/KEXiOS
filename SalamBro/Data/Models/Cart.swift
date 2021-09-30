//
//  Cart.swift
//  SalamBro
//
//  Created by Dan on 7/7/21.
//

import Foundation

struct Cart: Codable {
    var totalPrice: Double
    var deliveryType: String?
    var deliveryPrice: Double
    var positionsPrice: Double
    var positionsCount: Int?
    var items: [CartItem]
    var minPrice: Double
    var hasUnavailableProducts: Bool

    enum CodingKeys: String, CodingKey {
        case totalPrice = "total_price"
        case deliveryType = "delivery_type"
        case deliveryPrice = "delivery_price"
        case positionsPrice = "positions_price"
        case positionsCount = "positions_count"
        case items = "positions"
        case minPrice = "min_price"
        case hasUnavailableProducts = "has_unavailable_positions"
    }

    enum DeliveryType: String, Codable {
        case day = "DAY_DELIVERY"
        case night = "NIGHT_DELIVERY"
    }

    func getDeliveryType() -> DeliveryType? {
        return DeliveryType(rawValue: deliveryType ?? "")
    }
}

extension Cart {
    func getBadgeCount() -> String? {
        guard let count = positionsCount else { return nil }
        return positionsCount == 0 ? nil : String(count)
    }

    func toDTO() -> CartDTO {
        return .init(items: items.map { item in
            .init(
                positionUUID: item.position.uuid,
                count: item.count,
                comment: item.comment,
                modifiers: item.modifiers.map { modifierGroup in
                    .init(
                        modifierGroupUUID: modifierGroup.modifierGroupUUID,
                        positionUUID: modifierGroup.position.uuid,
                        count: modifierGroup.count
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
    var modifiers: [CartModifier]

    enum CodingKeys: String, CodingKey {
        case count, comment, position, modifiers
    }

    init(count: Int, comment: String?, position: CartPosition, modifierGroups: [CartModifier]) {
        self.count = count
        self.comment = comment
        self.position = position
        modifiers = modifierGroups
    }
}

extension CartItem: Equatable {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.comment == rhs.comment &&
            lhs.position == rhs.position &&
            lhs.modifiers == rhs.modifiers
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
    var category: String?
    var isAvailable: Bool
    var description: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, image, category, price, description
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

struct CartModifier: Codable, Equatable {
    let name: String
    let position: CartPosition
    let count: Int
    let modifierGroupUUID: String

    enum CodingKeys: String, CodingKey {
        case name, position, count
        case modifierGroupUUID = "modifier_group"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.position == rhs.position
    }
}
