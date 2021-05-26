//
//  LocationRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

protocol LocationRepository: AnyObject {
    func getCountries() -> [Country]?
    func changeCurrectCountry(to country: Country)
    func set(countries: [Country])
}

final class LocationRepositoryImpl: LocationRepository {
    private let storage: GeoStorage

    init(storage: GeoStorage) {
        self.storage = storage
    }

    func getCountries() -> [Country]? {
        guard
            let countries = storage.countries,
            countries != []
        else {
            return nil
        }

        return countries
    }

    func changeCurrectCountry(to country: Country) {
        storage.currentCountry = country
    }

    func set(countries: [Country]) {
        storage.countries = countries
    }
}
