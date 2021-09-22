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
    func makeCountriesRepository() -> CountriesRepository
    func makeCitiesRepository() -> CitiesRepository
    func makeMenuRepository() -> MenuRepository
    func makeMenuDetailRepository() -> MenuDetailRepository
    func makeDocumentsRepository() -> DocumentsRepository
    func makeRateOrderRepository() -> RateOrderRepository
    func makePaymentRepository() -> PaymentRepository
    func makeProfileRepository() -> ProfileRepository
    func makePushNotificationsRepository() -> PushNotificationsRepository
    func makeOrdersHistoryRepository() -> OrdersHistoryRepository
}

final class RepositoryComponentsAssembly: DependencyFactory, RepositoryComponents {
    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }

    func makeAddressRepository() -> AddressRepository {
        return shared(AddressRepositoryImpl(storage: makeLocalStorage(),
                                            authService: serviceComponents.authService(),
                                            brandStorage: makeLocalStorage(),
                                            ordersService: serviceComponents.ordersService(),
                                            authorizedApplyService: serviceComponents.authorizedApplyService(),
                                            profileService: serviceComponents.profileService(),
                                            yandexService: serviceComponents.yandexService(),
                                            defaultStorage: DefaultStorageImpl.sharedStorage,
                                            authTokenStorage: AuthTokenStorageImpl.sharedStorage))
    }

    func makeBrandRepository() -> BrandRepository {
        return shared(BrandRepositoryImpl(locationService: serviceComponents.locationService(),
                                          brandStorage: makeLocalStorage(),
                                          geoStorage: makeLocalStorage()))
    }

    func makeCartRepository() -> CartRepository {
        return shared(CartRepositoryImpl(cartStorage: makeLocalStorage(),
                                         ordersService: serviceComponents.ordersService(),
                                         defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makeAuthRepository() -> AuthRepository {
        return shared(AuthRepositoryImpl(authService: serviceComponents.authService(),
                                         profileService: serviceComponents.profileService(),
                                         ordersService: serviceComponents.ordersService(),
                                         authorizedApplyService: serviceComponents.authorizedApplyService(),
                                         notificationsService: serviceComponents.pushNotificationsService(),
                                         cartStorage: makeLocalStorage(),
                                         geoStorage: makeLocalStorage(),
                                         tokenStorage: AuthTokenStorageImpl.sharedStorage,
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
        return shared(MenuRepositoryImpl(menuService: serviceComponents.menuService(),
                                         ordersService: serviceComponents.ordersService(),
                                         storage: DefaultStorageImpl.sharedStorage))
    }

    func makeMenuDetailRepository() -> MenuDetailRepository {
        return shared(MenuDetailRepositoryImpl(menuService: serviceComponents.menuService()))
    }

    func makeDocumentsRepository() -> DocumentsRepository {
        return shared(DocumentsRepositoryImpl(storage: makeLocalStorage(),
                                              service: serviceComponents.documentsService()))
    }

    func makeRateOrderRepository() -> RateOrderRepository {
        return shared(RateOrderRepositoryImpl(rateService: serviceComponents.rateService()))
    }

    func makePaymentRepository() -> PaymentRepository {
        return weakShared(PaymentRepositoryImpl(paymentService: serviceComponents.paymentsService(),
                                                authorizedApplyService: serviceComponents.authorizedApplyService(),
                                                ordersService: serviceComponents.ordersService(),
                                                defaultStorage: DefaultStorageImpl.sharedStorage,
                                                cartStorage: makeLocalStorage(),
                                                addressStorage: makeLocalStorage(),
                                                reachabilityManager: ReachabilityManagerImpl.shared))
    }

    func makeProfileRepository() -> ProfileRepository {
        return shared(ProfileRepositoryImpl(profileService: serviceComponents.profileService(),
                                            authService: serviceComponents.authService(),
                                            tokenStorage: AuthTokenStorageImpl.sharedStorage))
    }

    func makePushNotificationsRepository() -> PushNotificationsRepository {
        return shared(PushNotificationsRepositoryImpl(
            notificationsService: serviceComponents.pushNotificationsService(),
            defaultStorage: DefaultStorageImpl.sharedStorage
        ))
    }

    func makeOrdersHistoryRepository() -> OrdersHistoryRepository {
        return shared(OrdersHistoryRepositoryImpl(ordersHistoryService: serviceComponents.ordersHistoryService()))
    }

    private func makeLocalStorage() -> Storage {
        return shared(.init())
    }
}
