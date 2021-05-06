//
//  AddressDTO.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

public struct AddressDTO: Codable {
    public var name: String
    public var longitude: Double
    public var latitude: Double
}

public extension AddressDTO {
    func toDomain() -> Address {
        .init(name: name,
              longitude: longitude,
              latitude: latitude)
    }

    init?(from domain: Address?) {
        guard let domain = domain else { return nil }
        name = domain.name
        longitude = domain.longitude
        latitude = domain.latitude
    }
}

extension AddressDTO: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
