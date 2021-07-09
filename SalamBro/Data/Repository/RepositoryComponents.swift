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
    func makeAuthRepository() -> AuthRepository
    func makeChangeUserInfoRepository() -> ChangeUserInfoRepository
    func makeCountriesRepository() -> CountriesRepository
    func makeCitiesRepository() -> CitiesRepository
    func makeMenuRepository() -> MenuRepository
    func makeMenuDetailRepository() -> MenuDetailRepository
    func makeDocumentsRepository() -> DocumentsRepository
}

final class RepositoryComponentsAssembly: DependencyFactory, RepositoryComponents {
    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }

    func makeAddressRepository() -> AddressRepository {
        return shared(AddressRepositoryImpl(storage: makeLocalStorage(),
                                            brandStorage: makeLocalStorage(),
                                            ordersService: serviceComponents.ordersService()))
    }

    func makeBrandRepository() -> BrandRepository {
        return shared(BrandRepositoryImpl(locationService: serviceComponents.locationService(),
                                          storage: makeLocalStorage()))
    }

    func makeCartRepository() -> CartRepository {
        return shared(CartRepositoryImpl(storage: makeLocalStorage()))
    }

    func makeAuthRepository() -> AuthRepository {
        return shared(AuthRepositoryImpl(authService: serviceComponents.authService(), tokenStorage: AuthTokenStorageImpl.sharedStorage))
    }

    func makeChangeUserInfoRepository() -> ChangeUserInfoRepository {
        return shared(ChangeUserInfoRepositoryImpl(service: serviceComponents.profileService(),
                                                   defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makeCountriesRepository() -> CountriesRepository {
        return shared(CountriesRepositoryImpl(locationService: serviceComponents.locationService(),
                                              storage: makeLocalStorage()))
    }

    func makeCitiesRepository() -> CitiesRepository {
        return shared(CitiesRepositoryImpl(locationService: serviceComponents.locationService(),
                                           storage: makeLocalStorage()))
    }

    func makeMenuRepository() -> MenuRepository {
        return shared(MenuRepositoryImpl(ordersService: serviceComponents.ordersService(),
                                         promotionsService: serviceComponents.promotionsService(),
                                         storage: DefaultStorageImpl.sharedStorage))
    }

    func makeMenuDetailRepository() -> MenuDetailRepository {
        return shared(MenuDetailRepositoryImpl(ordersService: serviceComponents.ordersService()))
    }

    func makeDocumentsRepository() -> DocumentsRepository {
        return shared(DocumentsRepositoryImpl(storage: makeLocalStorage(),
                                              service: serviceComponents.documentsService()))
    }

    private func makeLocalStorage() -> Storage {
        return shared(.init())
    }
}
