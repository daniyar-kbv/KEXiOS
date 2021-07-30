//
//  Address.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

class UserAddress: Decodable {
    var id: Int? = nil
    var address: Address
    var createdAt: String? = nil
    var updatedAt: String? = nil
    var isCurrent: Bool
    var user: Int? = nil
    var brandId: Int? = nil

    init(address: Address,
         isCurrent: Bool,
         brandId: Int?)
    {
        self.address = address
        self.isCurrent = isCurrent
        self.brandId = brandId
    }

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

class Address: Decodable {
    var id: Int? = nil
    var district: String?
    var street: String?
    var building: String?
    var corpus: String?
    var flat: String?
    var comment: String?
    var country: Country?
    var city: City?
    var longitude: Double?
    var latitude: Double?

    init(district: String?,
         street: String?,
         building: String?,
         corpus: String?,
         flat: String?,
         comment: String?,
         country: Country?,
         city: City?,
         longitude: Double?,
         latitude: Double?)
    {
        self.district = district
        self.street = street
        self.building = building
        self.corpus = corpus
        self.flat = flat
        self.comment = comment
        self.country = country
        self.city = city
        self.longitude = longitude
        self.latitude = latitude
    }
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
