//
//  ModelsForOrdersHistory.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/16/21.
//

import Foundation

class Brand2: Codable {
    let id: Int
    let name: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
    }
}

class Address2: Codable {
    var district: String?
    var street: String?
    var building: String?
    var corpus: String?
    var flat: String?
    var comment: String?
    var country: Country2?
    var city: City2?
    var longitude: Double?
    var latitude: Double?
    var fullAddress: String

    enum CodingKeys: String, CodingKey {
        case district, street, building, corpus, flat, comment, country, city, longitude, latitude
        case fullAddress = "full_address"
    }
}

public struct Country2: Codable {
    let id: Int
    let name: String
    let countryCode: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case countryCode = "country_code"
    }
}

public class City2: Codable {
    let id: Int
    let name: String
    let latitude: Double?
    let longitude: Double?
}

struct Cart2: Codable {
    var items: [CartItem2]

    enum CodingKeys: String, CodingKey {
        case items = "positions"
    }
}

struct CartItem2: Codable {
    var count: Int
    var comment: String?
    var position: CartPosition2
    var modifierGroups: [CartModifierGroup2]

    enum CodingKeys: String, CodingKey {
        case count, comment, position
        case modifierGroups = "modifier_groups"
    }
}

struct CartPosition2: Codable, Equatable {
    var uuid: String
    var name: String
    var image: String?
    var price: Double
    var categoryUUID: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case uuid, name, image, price, description
        case categoryUUID = "category"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

struct CartModifierGroup2: Codable, Equatable {
    var name: String
    let uuid: String
    var modifiers: [CartModifier2]

    enum CodingKeys: String, CodingKey {
        case modifiers, name
        case uuid = "modifier_group"
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid &&
            lhs.modifiers == rhs.modifiers
    }
}

struct CartModifier2: Codable, Equatable {
    var position: CartPosition2
    var count: Int

    enum CodingKeys: String, CodingKey {
        case position, count
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.position == rhs.position
    }
}
