//
//  Menu.swift
//  SalamBro
//
//  Created by Dan on 6/29/21.
//

import Foundation

struct MenuCategory: Codable {
    let name: String
    let uuid: String
    let positions: [MenuPosition]
}

struct MenuPosition: Codable {
    let uuid: String
    let name: String
    let price: Double?
    let description: String?
    let imageSmall: String?
    let imageBig: String?
    let status: Bool
    let categoryUUID: String

    enum CodingKeys: String, CodingKey {
        case uuid, name, description, price
        case categoryUUID = "category"
        case status = "is_available"
        case imageSmall = "image_small"
        case imageBig = "image_big"
    }
}

struct AdditionalPosition: Codable {
    let uuid: String
    let name: String
    let price: Int
    let description: String?
    let imageSmall: String?
    let imageBig: String?
    let count: Int
    let isAvailable: Bool
    let categoryUUID: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, description, price, count
        case isAvailable = "is_available"
        case categoryUUID = "category"
        case imageSmall = "image_small"
        case imageBig = "image_big"
    }
}

struct MenuPositionDetail: Codable {
    let uuid: String
    let name: String
    let description: String?
    let imageSmall: String?
    let imageBig: String?
    let price: Double
    let categoryUUID: String
    var modifierGroups: [ModifierGroup]

    enum CodingKeys: String, CodingKey {
        case uuid, name, description, price
        case modifierGroups = "modifier_groups"
        case categoryUUID = "branch_category"
        case imageSmall = "image_small"
        case imageBig = "image_big"
    }
}

struct ModifierGroup: Codable, Equatable {
    let uuid: String
    let name: String
    let minAmount: Int
    let maxAmount: Int
    let isRequired: Bool
    var modifiers: [Modifier]

    var selectedModifiers: [Modifier] = []
    var totalCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case uuid, name, modifiers
        case minAmount = "min_amount"
        case maxAmount = "max_amount"
        case isRequired = "is_required"
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

struct Modifier: Codable {
    let name: String
    let uuid: String
    let imageSmall: String?
    let imageBig: String?

    var itemCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case name, uuid
        case imageSmall = "image_small"
        case imageBig = "image_big"
    }
}

extension MenuPositionDetail {
    func toCartItem(count: Int, comment: String?, description: String?, type: CartPosition.PositionType)
        -> CartItem
    {
        return .init(
            count: count,
            comment: comment,
            position: .init(
                uuid: uuid,
                name: name,
                image: imageSmall,
                price: price,
                positionType: type.rawValue,
                isAvailable: true,
                description: description
            ),
            modifierGroups: modifierGroups
                .filter { !$0.modifiers.filter { $0.itemCount != 0 }.isEmpty }
                .map { modifierGroup in
                    .init(
                        uuid: modifierGroup.uuid,
                        modifiers: modifierGroup.modifiers
                            .filter { $0.itemCount != 0 }
                            .map { modifier in
                                .init(
                                    position: .init(
                                        uuid: modifier.uuid,
                                        name: modifier.name,
                                        image: modifier.imageSmall,
                                        positionType: CartPosition.PositionType.modifier.rawValue,
                                        isAvailable: true
                                    ),
                                    count: modifier.itemCount
                                )
                            }
                    )
                }
        )
    }
}

extension AdditionalPosition {
    func toCartItem(count: Int, comment: String, modifiers _: [Modifier], type: CartPosition.PositionType) -> CartItem {
        return .init(
            count: count,
            comment: comment,
            position: .init(
                uuid: uuid,
                name: name,
                image: imageSmall,
                price: Double(price),
                positionType: type.rawValue,
                isAvailable: true,
                description: ""
            ),
            modifierGroups: []
        )
    }
}

extension Modifier {
    mutating func set(itemCount: Int) {
        self.itemCount = itemCount
    }
}

extension ModifierGroup {
    mutating func set(modifiers: [Modifier]) {
        self.modifiers = modifiers
    }

    mutating func set(selectedModifiers: [Modifier]) {
        self.selectedModifiers = selectedModifiers
    }

    mutating func set(totalCount: Int) {
        self.totalCount = totalCount
    }
}
