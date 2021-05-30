//
//  LocationRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

protocol LocationRepository: AnyObject {
    func getCurrentCountry() -> Country?
    func getCountries() -> [Country]?
    func changeCurrectCountry(to country: Country)
    func set(countries: [Country])

    func getCurrectCity() -> City?
    func getCities() -> [City]?
    func changeCurrentCity(to city: City)
    func set(cities: [City])
}

final class LocationRepositoryImpl: LocationRepository {
    private let storage: GeoStorage

    init(storage: GeoStorage) {
        self.storage = storage
    }
}

// MARK: Countries

extension LocationRepositoryImpl {
    func getCurrentCountry() -> Country? {
        return storage.currentCountry
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

// MARK: Cities

extension LocationRepositoryImpl {
    func getCurrectCity() -> City? {
        return storage.currentCity
    }

    func getCities() -> [City]? {
        guard
            let cities = storage.cities,
            cities != []
        else {
            return nil
        }

        return cities
    }

    func changeCurrentCity(to city: City) {
        storage.currentCity = city
    }

    func set(cities: [City]) {
        storage.cities = cities
    }
}
