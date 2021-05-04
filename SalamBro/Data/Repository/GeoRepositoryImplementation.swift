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

    public func downloadCountries() -> Promise<[Country]> {
        provider.downloadCountries().map { $0.countries.map { $0.toDomain() } }
    }

    public func downloadCities(country id: Int) -> Promise<[String]> {
        provider.downloadCities(country: id).map { $0.cities }
    }
}
