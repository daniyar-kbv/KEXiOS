//
//  Country.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

public struct CountryDTO: Codable {
    let id: Int
    let name: String
    let callingCode: String
}

public extension CountryDTO {
    func toDomain() -> Country {
        .init(id: id,
              name: name,
              callingCode: callingCode)
    }

    init?(from domain: Country?) {
        guard let domain = domain else { return nil }
        id = domain.id
        name = domain.name
        callingCode = domain.callingCode
    }
}
