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

struct ModifierGroup: Codable {
    let uuid: String
    let name: String
    let minAmount: Int
    let maxAmount: Int
    let isRequired: Bool
    let modifiers: [Modifier]

    lazy var selectedModifiers: [Modifier] = []

    enum CodingKeys: String, CodingKey {
        case uuid, name, modifiers
        case minAmount = "min_amount"
        case maxAmount = "max_amount"
        case isRequired = "is_required"
    }
}

struct Modifier: Codable {
    let name: String
    let uuid: String
    let image: String?
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
                var modifierGroup = modifierGroup
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

extension ModifierGroup {
    mutating func set(modifier: Modifier, at index: Int) {
        selectedModifiers[index] = modifier
    }
}
