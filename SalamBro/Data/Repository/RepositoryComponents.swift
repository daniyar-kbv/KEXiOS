//
//  RepositoryComponents.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

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

    private lazy var localStorage: Storage = shared(.init())

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents

        super.init()

        Single<Any>.geoStorage = localStorage
    }

    func makeAddressRepository() -> AddressRepository {
        return shared(AddressRepositoryImpl(storage: localStorage,
                                            authService: serviceComponents.authService(),
                                            brandStorage: localStorage,
                                            ordersService: serviceComponents.ordersService(),
                                            authorizedApplyService: serviceComponents.authorizedApplyService(),
                                            profileService: serviceComponents.profileService(),
                                            yandexService: serviceComponents.yandexService(),
                                            defaultStorage: DefaultStorageImpl.sharedStorage,
                                            authTokenStorage: AuthTokenStorageImpl.sharedStorage))
    }

    func makeBrandRepository() -> BrandRepository {
        return shared(BrandRepositoryImpl(locationService: serviceComponents.locationService(),
                                          brandStorage: localStorage,
                                          geoStorage: localStorage))
    }

    func makeCartRepository() -> CartRepository {
        return shared(CartRepositoryImpl(cartStorage: localStorage,
                                         ordersService: serviceComponents.ordersService(),
                                         defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makeAuthRepository() -> AuthRepository {
        return shared(AuthRepositoryImpl(authService: serviceComponents.authService(),
                                         profileService: serviceComponents.profileService(),
                                         ordersService: serviceComponents.ordersService(),
                                         authorizedApplyService: serviceComponents.authorizedApplyService(),
                                         notificationsService: serviceComponents.pushNotificationsService(),
                                         cartStorage: localStorage,
                                         geoStorage: localStorage,
                                         tokenStorage: AuthTokenStorageImpl.sharedStorage,
                                         defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makeCountriesRepository() -> CountriesRepository {
        return shared(CountriesRepositoryImpl(locationService: serviceComponents.locationService(),
                                              storage: localStorage))
    }

    func makeCitiesRepository() -> CitiesRepository {
        return shared(CitiesRepositoryImpl(locationService: serviceComponents.locationService(),
                                           storage: localStorage))
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
        return shared(DocumentsRepositoryImpl(storage: localStorage,
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
                                                cartStorage: localStorage,
                                                addressStorage: localStorage,
                                                reachabilityManager: ReachabilityManagerImpl.shared))
    }

    func makeProfileRepository() -> ProfileRepository {
        return shared(ProfileRepositoryImpl(profileService: serviceComponents.profileService(),
                                            authService: serviceComponents.authService(),
                                            tokenStorage: AuthTokenStorageImpl.sharedStorage,
                                            defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makePushNotificationsRepository() -> PushNotificationsRepository {
        return shared(PushNotificationsRepositoryImpl(
            notificationsService: serviceComponents.pushNotificationsService(),
            defaultStorage: DefaultStorageImpl.sharedStorage
        ))
    }

    func makeOrdersHistoryRepository() -> OrdersHistoryRepository {
        return shared(OrdersHistoryRepositoryImpl(
            ordersHistoryService: serviceComponents.ordersHistoryService(),
            storage: localStorage
        ))
    }
}
