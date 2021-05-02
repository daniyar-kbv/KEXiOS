//
//  Country.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

public struct CountryUI {
    let id: String
    let name: String
    let callingCode: String
    var marked: Bool = false
}

public extension CountryUI {
    func toDomain() -> Country {
        .init(id: id,
              name: name,
              callingCode: callingCode,
              marked: marked)
    }

    init(from domain: Country) {
        id = domain.id
        name = domain.name
        callingCode = domain.callingCode
        marked = domain.marked
    }
}
