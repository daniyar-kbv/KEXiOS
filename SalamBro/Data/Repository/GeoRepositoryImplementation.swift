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

    public init(provider: GeoProvider) {
        self.provider = provider
    }

    public func downloadCountries() -> Promise<[Country]> {
        provider.downloadCountries().map { $0.countries.map { $0.toDomain() } }
    }

    public func downloadCities(country id: Int) -> Promise<[String]> {
        provider.downloadCities(country: id).map { $0.cities }
    }
}
