//
//  GeoStorage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

public protocol GeoStorage: AnyObject {
    var currentCountry: CountryDTO? { get set }
    var currentCity: String? { get set }
    var countries: [CountryDTO]? { get set }
    var cities: [String]? { get set }
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

    public var currentCountry: CountryDTO? {
        get { get(key: Keys.currentCountry.rawValue) }
        set { save(key: Keys.currentCountry.rawValue, object: newValue) }
    }

    public var currentCity: String? {
        get { get(key: Keys.currentCity.rawValue) }
        set { save(key: Keys.currentCity.rawValue, object: newValue) }
    }

    public var countries: [CountryDTO]? {
        get { get(key: Keys.countries.rawValue) }
        set { save(key: Keys.countries.rawValue, object: newValue) }
    }

    public var cities: [String]? {
        get { get(key: Keys.cities.rawValue) }
        set { save(key: Keys.cities.rawValue, object: newValue) }
    }

    public var addresses: [AddressDTO]? {
        get { get(key: Keys.addresses.rawValue) }
        set { save(key: Keys.addresses.rawValue, object: newValue) }
    }

    public var currentAddress: AddressDTO? {
        get { get(key: Keys.currentAddress.rawValue) }
        set { save(key: Keys.currentAddress.rawValue, object: newValue) }
    }
}
