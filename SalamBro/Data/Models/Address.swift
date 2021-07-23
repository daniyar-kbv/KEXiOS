//
//  Address.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

//  Tech debt: leave only Address or MapAddress

class UserAddress: Codable {
    let id: Int?
    var address: Address
    let createdAt: String
    let updatedAt: String
    var isCurrent: Bool
    let user: Int
    var brandId: Int?

    enum CodingKeys: String, CodingKey {
        case id, address, isCurrent, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandId = "local_brand"
    }
}

extension UserAddress {
    func isComplete() -> Bool {
        return address.isComplete() && brandId != nil
    }
}

extension UserAddress: Equatable {
    public static func == (lhs: UserAddress, rhs: UserAddress) -> Bool {
        guard let lhsId = lhs.id,
              let rhsId = rhs.id
        else {
            return lhs.address == rhs.address
        }
        return lhsId == rhsId
    }
}

class Address: Codable {
    var id: Int?
    var district: String?
    var street: String?
    var building: String?
    var corpus: String?
    var flat: String?
    var comment: String?
    var country: Country?
    var city: City?
    var longitude: Double
    var latitude: Double
}

extension Address {
    func getName() -> String {
        return ""
    }

    func isComplete() -> Bool {
        return country != nil && city != nil && !getName().isEmpty
    }
}

extension Address: Equatable {
    public static func == (lhs: Address, rhs: Address) -> Bool {
        guard let lhsId = lhs.id,
              let rhsId = rhs.id
        else {
            return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
        }
        return lhsId == rhsId
    }
}
