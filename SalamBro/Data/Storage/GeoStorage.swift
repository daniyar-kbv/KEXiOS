//
//  GeoStorage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

protocol GeoStorage: AnyObject {
    var currentCountry: Country? { get set }
    var currentCity: City? { get set }
    var countries: [Country]? { get set }
    var cities: [City]? { get set }
    var addresses: [AddressDTO]? { get set }
    var currentAddress: AddressDTO? { get set }
}

extension Storage: GeoStorage {
    private enum Keys: String {
        case currentCountry
        case currentCity
        case countries
        case cities
        case addresses
        case currentAddress
    }

    var currentCountry: Country? {
        get { get(key: Keys.currentCountry.rawValue) }
        set { save(key: Keys.currentCountry.rawValue, object: newValue) }
    }

    var currentCity: City? {
        get { get(key: Keys.currentCity.rawValue) }
        set { save(key: Keys.currentCity.rawValue, object: newValue) }
    }

    var countries: [Country]? {
        get { get(key: Keys.countries.rawValue) }
        set { save(key: Keys.countries.rawValue, object: newValue) }
    }

    var cities: [City]? {
        get { get(key: Keys.cities.rawValue) }
        set { save(key: Keys.cities.rawValue, object: newValue) }
    }

    var addresses: [AddressDTO]? {
        get { get(key: Keys.addresses.rawValue) }
        set { save(key: Keys.addresses.rawValue, object: newValue) }
    }

    var currentAddress: AddressDTO? {
        get { get(key: Keys.currentAddress.rawValue) }
        set { save(key: Keys.currentAddress.rawValue, object: newValue) }
    }
}
