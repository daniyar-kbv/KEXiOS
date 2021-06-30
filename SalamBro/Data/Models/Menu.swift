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
    let modifierGroups: [ModifierGroup]

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
}

extension MenuPositionDetail {
    func toCartItem(count: Int, comment: String) -> CartItem {
        return .init(
            positionUUID: uuid,
            count: count,
            comment: comment,
            position: .init(
                uuid: uuid,
                name: name,
                image: image,
                description: description,
                price: price,
                categoryUUID: categoryUUID
            ),
            modifiers: []
        )
    }
}
