//
//  ServiceComponents.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Moya

protocol ServiceComponents: AnyObject {
    func authService() -> AuthService
    func locationService() -> LocationService
    func ordersService() -> OrdersService
    func promotionsService() -> PromotionsService
    func profileService() -> ProfileService
    func documentsService() -> DocumentsService
    func rateService() -> RateService
    func paymentsService() -> PaymentsService
    func pushNotificationsService() -> PushNotificationsService
}

final class ServiceComponentsAssembly: DependencyFactory, ServiceComponents {
    // MARK: Network logger

    private let networkPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))

    // MARK: Auth Plugin for authorized requests

    private let authPlugin = AuthPlugin(authTokenStorage: AuthTokenStorageImpl.sharedStorage)

    // MARK: Language Plugin to pass language code to headers

    private let languagePlugin = LanguagePlugin(defaultStorage: DefaultStorageImpl.sharedStorage)

    func authService() -> AuthService {
        return shared(AuthServiceMoyaImpl(provider: MoyaProvider<AuthAPI>(plugins: [networkPlugin, languagePlugin])))
    }

    func locationService() -> LocationService {
        return shared(LocationServiceMoyaImpl(provider: MoyaProvider<LocationAPI>(plugins: [networkPlugin, languagePlugin])))
    }

    func ordersService() -> OrdersService {
        return shared(OrdersServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, languagePlugin, authPlugin])))
    }

    func promotionsService() -> PromotionsService {
        return shared(PromotionsServiceImpl(provider: MoyaProvider<PromotionsAPI>(plugins: [networkPlugin, languagePlugin])))
    }

    func profileService() -> ProfileService {
        return shared(ProfileServiceMoyaImpl(provider: MoyaProvider<ProfileAPI>(plugins: [networkPlugin, languagePlugin, authPlugin])))
    }

    func documentsService() -> DocumentsService {
        return shared(DocumentsServiceImpl(provider: MoyaProvider<DocumentsAPI>(plugins: [networkPlugin, languagePlugin])))
    }

    func rateService() -> RateService {
        return shared(RateServiceImpl(provider: MoyaProvider<RateAPI>(plugins: [networkPlugin, languagePlugin, authPlugin])))
    }

    func pushNotificationsService() -> PushNotificationsService {
        return shared(PushNotificationsServiceMoyaImpl(provider: MoyaProvider<PushNotificationsAPI>(plugins: [networkPlugin, languagePlugin, authPlugin])))
    }

    func paymentsService() -> PaymentsService {
        return shared(PaymentsServiceMoyaImpl(provider: MoyaProvider<PaymentsAPI>(plugins: [networkPlugin, languagePlugin, authPlugin])))
    }
}
