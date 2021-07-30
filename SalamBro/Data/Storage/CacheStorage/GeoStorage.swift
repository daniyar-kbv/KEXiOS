//
//  GeoStorage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

protocol GeoStorage: AnyObject {
    var countries: [Country]? { get set }
    var cities: [City]? { get set }
    var userAddresses: [UserAddress] { get set }
}

extension Storage: GeoStorage {
    private enum Keys: String {
        case countries
        case cities

        case userAddresses
    }

    var countries: [Country]? {
        get { get(key: Keys.countries.rawValue) }
        set { save(key: Keys.countries.rawValue, object: newValue) }
    }

    var cities: [City]? {
        get { get(key: Keys.cities.rawValue) }
        set { save(key: Keys.cities.rawValue, object: newValue) }
    }

    var userAddresses: [UserAddress] {
        get { get(key: Keys.userAddresses.rawValue) ?? [] }
        set { save(key: Keys.userAddresses.rawValue, object: newValue) }
    }
}
