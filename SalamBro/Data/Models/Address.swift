//
//  Address.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

class UserAddress: Codable {
    var id: Int?
    var address: Address
    var createdAt: String?
    var updatedAt: String?
    var isCurrent: Bool
    var user: Int?
    var brand: Brand?

    init(id: Int?,
         address: Address,
         createdAt: String?,
         updatedAt: String?,
         isCurrent: Bool,
         user: Int?,
         brand: Brand?)
    {
        self.id = id
        self.address = address
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isCurrent = isCurrent
        self.user = user
        self.brand = brand
    }

    init(address: Address,
         isCurrent: Bool)
    {
        self.address = address
        self.isCurrent = isCurrent
    }

    init() {
        address = .init()
        isCurrent = false
    }

    enum CodingKeys: String, CodingKey {
        case id, address, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brand = "local_brand"
        case isCurrent = "is_current"
    }
}

extension UserAddress {
    func isComplete() -> Bool {
        return address.isComplete() && brand != nil
    }

    func getCopy() -> UserAddress {
        return .init(id: id, address: address, createdAt: createdAt, updatedAt: updatedAt, isCurrent: isCurrent, user: user, brand: brand?.getCopy())
    }

    func toDTO() -> OrderApplyDTO? {
        guard let countryId = address.country?.id,
              let cityId = address.city?.id,
              let longitude = address.longitude?.rounded(to: 8),
              let latitude = address.latitude?.rounded(to: 8),
              let brandId = brand?.id
        else { return nil }
        return .init(address: .init(city: cityId,
                                    longitude: longitude,
                                    latitude: latitude,
                                    district: address.district,
                                    street: address.street,
                                    building: address.building,
                                    corpus: address.corpus,
                                    flat: address.flat,
                                    comment: address.comment,
                                    country: countryId),
                     localBrand: brandId)
    }
}

extension UserAddress: Equatable {
    public static func == (lhs: UserAddress, rhs: UserAddress) -> Bool {
        return lhs.id == rhs.id && lhs.brand == rhs.brand
    }
}

class Address: Codable {
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
    var fullAddress: String?

    init(district: String?,
         street: String?,
         building: String?,
         corpus: String?,
         flat: String?,
         comment: String?,
         country: Country?,
         city: City?,
         longitude: Double?,
         latitude: Double?,
         fullAddress: String?)
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
        self.fullAddress = fullAddress
    }

    init() {
        district = nil
        street = nil
        building = nil
        corpus = nil
        flat = nil
        comment = nil
        country = nil
        city = nil
        longitude = nil
        latitude = nil
        fullAddress = nil
    }

    enum CodingKeys: String, CodingKey {
        case district, street, building, corpus, flat, comment, country, city, longitude, latitude
        case fullAddress = "full_address"
    }
}

extension Address {
    func getName() -> String? {
        if let fullAddress = fullAddress {
            return fullAddress
        } else if let district = district, let street = street, let building = building {
            return "\(district), \(street) \(building)"
        } else if let district = district, let building = building {
            return "\(district) \(building)"
        } else if let street = street, let building = building {
            return "\(street) \(building)"
        }
        return nil
    }

    func isComplete() -> Bool {
        return country != nil &&
            city != nil &&
            (district != nil || street != nil) &&
            building != nil
    }

    func getCopy() -> Address {
        return .init(district: district, street: street, building: building, corpus: corpus, flat: flat, comment: comment, country: country?.getCopy(), city: city?.getCopy(), longitude: longitude, latitude: latitude, fullAddress: fullAddress)
    }
}

extension Address: Equatable {
    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}

struct UpdateAddress: Codable {
    let id: String

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
    }
}
