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
    let description: String?
    let image: String?
    let price: Double?
    let categoryUUID: String

    enum CodingKeys: String, CodingKey {
        case uuid, name, description, image, price
        case categoryUUID = "category"
    }
}

struct MenuPositionDetail: Codable {
    let uuid: String
    let name: String
    let description: String?
    let image: String?
    let price: Double
    let categoryUUID: String
    var modifierGroups: [ModifierGroup]

    enum CodingKeys: String, CodingKey {
        case uuid, name, description, image, price
        case modifierGroups = "modifier_groups"
        case categoryUUID = "branch_category"
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
    let image: String?

    var itemCount: Int = 0

    enum CodingKeys: String, CodingKey {
        case name, uuid, image
    }
}

extension MenuPositionDetail {
    func toCartItem(count: Int, comment: String, modifiers _: [Modifier]) -> CartItem {
        return .init(
            count: count,
            comment: comment,
            position: .init(
                uuid: uuid,
                name: name,
                image: image,
                price: price,
                categoryUUID: categoryUUID
            ),
            modifierGroups: modifierGroups.map { modifierGroup in
                let modifierGroup = modifierGroup
                return .init(
                    uuid: modifierGroup.uuid,
                    modifiers: modifierGroup.selectedModifiers.compactMap { $0 }.map { modifier in
                        .init(
                            position: .init(
                                uuid: modifier.uuid,
                                name: modifier.name,
                                image: modifier.image
                            ),
                            count: 1
                        )
                    }
                )
            }
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
