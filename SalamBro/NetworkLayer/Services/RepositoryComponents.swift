//
//  RepositoryComponents.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation

protocol RepositoryComponents: AnyObject {
    func makeAddressRepository() -> AddressRepository
    func makeBrandRepository() -> BrandRepository
    func makeCartRepository() -> CartRepository
    func makeChangeUserInfoRepository() -> ChangeUserInfoRepository
    func makeCountriesRepository() -> CountriesRepository
    func makeCitiesRepository() -> CitiesRepository
}

final class RepositoryComponentsAssembly: DependencyFactory, RepositoryComponents {
    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }

    func makeAddressRepository() -> AddressRepository {
        return shared(AddressRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeBrandRepository() -> BrandRepository {
        return shared(BrandRepositoryImpl(locationService: serviceComponents.locationService(), storage: makeLocalStorage()))
    }

    func makeCartRepository() -> CartRepository {
        return shared(CartRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeChangeUserInfoRepository() -> ChangeUserInfoRepository {
        return shared(ChangeUserInfoRepositoryImpl(service: serviceComponents.profileService(), defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makeCountriesRepository() -> CountriesRepository {
        return shared(CountriesRepositoryImpl(locationService: serviceComponents.locationService(), storage: makeLocalStorage()))
    }

    func makeCitiesRepository() -> CitiesRepository {
        return shared(CitiesRepositoryImpl(locationService: serviceComponents.locationService(), storage: makeLocalStorage()))
    }

    private func makeLocalStorage() -> Storage {
        return shared(.init())
    }
}
