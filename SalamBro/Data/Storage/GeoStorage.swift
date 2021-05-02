//
//  GeoStorage.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation

public protocol GeoStorage: AnyObject {
    var currentCountry: CountryDTO? { get set }
}

extension Storage: GeoStorage {
    private enum Keys: String {
        case currentCountry
    }

    public var currentCountry: CountryDTO? {
        get { get(key: Keys.currentCountry.rawValue) }
        set { save(key: Keys.currentCountry.rawValue, object: newValue) }
    }
}
