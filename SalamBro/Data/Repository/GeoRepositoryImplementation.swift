//
//  GeoRepositoryImplementation.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit

// Tech debt: remove

final class GeoRepositoryImplementation
//    :GeoRepository
{
    private let provider: GeoProvider
    private let storage: GeoStorage

    init(provider: GeoProvider,
         storage: GeoStorage)
    {
        self.provider = provider
        self.storage = storage
    }

//    var currentCountry: Country? {
//        get { storage.currentCountry }
//        set { storage.currentCountry = newValue }
//    }
//
//    var currentCity: City? {
//        get { storage.currentCity }
//        set { storage.currentCity = newValue }
//    }
//
//    var addresses: [Address]? {
//        get { storage.addresses?.map { $0.toDomain() } ?? [] }
//        set { storage.addresses = newValue?.compactMap { AddressDTO(from: $0) }.uniqued() }
//    }
//
//    var currentAddress: Address? {
//        get { storage.currentAddress?.toDomain() }
//        set { storage.currentAddress = AddressDTO(from: newValue) }
//    }

    var countries: [Country] { storage.countries ?? [] }
    var cities: [City] { storage.cities ?? [] }
}
