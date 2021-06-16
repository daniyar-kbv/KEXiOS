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

    var deliveryAddresses: [DeliveryAddress]? { get set }
    var currentDeliveryAddressIndex: Int? { get set }
}

extension Storage: GeoStorage {
    private enum Keys: String {
        case countries
        case cities

        case deliveryAddresses
        case currentDeliveryAddressIndex
    }

    var countries: [Country]? {
        get { get(key: Keys.countries.rawValue) }
        set { save(key: Keys.countries.rawValue, object: newValue) }
    }

    var cities: [City]? {
        get { get(key: Keys.cities.rawValue) }
        set { save(key: Keys.cities.rawValue, object: newValue) }
    }

    var deliveryAddresses: [DeliveryAddress]? {
        get { get(key: Keys.deliveryAddresses.rawValue) }
        set { save(key: Keys.deliveryAddresses.rawValue, object: newValue) }
    }

    var currentDeliveryAddressIndex: Int? {
        get { get(key: Keys.currentDeliveryAddressIndex.rawValue) }
        set { save(key: Keys.currentDeliveryAddressIndex.rawValue, object: newValue) }
    }
}
