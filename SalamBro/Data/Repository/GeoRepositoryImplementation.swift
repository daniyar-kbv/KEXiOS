//
//  GeoRepositoryImplementation.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit

public final class GeoRepositoryImplementation: GeoRepository {
    private let provider: GeoProvider
    private let storage: GeoStorage

    public init(provider: GeoProvider,
                storage: GeoStorage)
    {
        self.provider = provider
        self.storage = storage
    }

    public var currentCountry: Country? {
        get { storage.currentCountry?.toDomain() }
        set { storage.currentCountry = CountryDTO(from: newValue) }
    }

    public var currentCity: String? {
        get { storage.currentCity }
        set { storage.currentCity = newValue }
    }

    public var countries: [Country] { storage.countries?.map { $0.toDomain() } ?? [] }
    public var cities: [String] { storage.cities ?? [] }

    public func downloadCountries() -> Promise<[Country]> {
        provider.downloadCountries().get {
            self.storage.countries = $0.countries
        }.map { $0.countries.map { $0.toDomain() } }
    }

    public func downloadCities(country id: Int) -> Promise<[String]> {
        provider.downloadCities(country: id).map { $0.cities }.get {
            self.storage.cities = $0
        }
    }
}
