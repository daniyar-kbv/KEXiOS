//
//  RepositoryComponents.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation

protocol RepositoryComponents: AnyObject {
    func makeLocationRepository() -> LocationRepository
    func makeBrandRepository() -> BrandRepository
    func makeCartRepository() -> CartRepository
    func makeCitiesRepository() -> CitiesRepository
    func makeCountriesRepository() -> CountriesRepository
}

final class RepositoryComponentsAssembly: DependencyFactory, RepositoryComponents {
    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }

    func makeLocationRepository() -> LocationRepository {
        return shared(LocationRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeBrandRepository() -> BrandRepository {
        return shared(BrandRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeCartRepository() -> CartRepository {
        return shared(CartRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeCitiesRepository() -> CitiesRepository {
        return shared(CitiesRepositoryImpl(locationService: serviceComponents.locationService(), storage: makeLocalStorage()))
    }

    func makeCountriesRepository() -> CountriesRepository {
        return shared(CountriesRepositoryImpl(locationService: serviceComponents.locationService(), storage: makeLocalStorage()))
    }

    private func makeLocalStorage() -> Storage {
        return shared(.init())
    }
}
