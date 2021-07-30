//
//  Country.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

public struct Country: Codable {
    let id: Int
    let name: String
    let countryCode: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case countryCode = "country_code"
    }
}

extension Country {
    func getCopy() -> Country {
        return .init(id: id, name: name, countryCode: countryCode)
    }
}

extension Country: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
