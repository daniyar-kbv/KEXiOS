//
//  Country.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

public struct CountryUI {
    let id: Int
    let name: String
    let callingCode: String
}

public extension CountryUI {
    func toDomain() -> Country {
        .init(id: id,
              name: name,
              callingCode: callingCode)
    }

    init(from domain: Country) {
        id = domain.id
        name = domain.name
        callingCode = domain.callingCode
    }
}
