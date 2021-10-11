//
//  ServiceComponents.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Moya
import RxSwift

protocol ServiceComponents: AnyObject {
    func authService() -> AuthService
    func locationService() -> LocationService
    func ordersService() -> OrdersService
    func authorizedApplyService() -> AuthorizedApplyService
    func menuService() -> MenuService
    func profileService() -> ProfileService
    func yandexService() -> YandexService
    func documentsService() -> DocumentsService
    func rateService() -> RateService
    func paymentsService() -> PaymentsService
    func pushNotificationsService() -> PushNotificationsService
    func ordersHistoryService() -> OrdersHistoryService
}

final class ServiceComponentsAssembly: DependencyFactory, ServiceComponents {
    // MARK: Network logger

    private let networkPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))

    // MARK: Auth Plugin for authorized requests

    private let authPlugin = AuthPlugin(authTokenStorage: AuthTokenStorageImpl.sharedStorage)

    // MARK: Language Plugin to pass language code to headers

    private let configurationPlugin = ConfigurationPlugin(defaultStorage: DefaultStorageImpl.sharedStorage)

    private lazy var authProvider = MoyaProvider<AuthAPI>(plugins: [networkPlugin, configurationPlugin])

    override init() {
        super.init()

        Single<Any>.authProvider = authProvider
    }

    func authService() -> AuthService {
        return shared(AuthServiceMoyaImpl(provider: authProvider))
    }

    func locationService() -> LocationService {
        return shared(LocationServiceMoyaImpl(provider: MoyaProvider<LocationAPI>(plugins: [networkPlugin, configurationPlugin])))
    }

    func ordersService() -> OrdersService {
        return shared(OrdersServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, configurationPlugin])))
    }

    func authorizedApplyService() -> AuthorizedApplyService {
        return shared(AuthorizedApplyServiceImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, configurationPlugin, authPlugin])))
    }

    func menuService() -> MenuService {
        return shared(MenuServiceImpl(provider: MoyaProvider<MenuAPI>(plugins: [networkPlugin, configurationPlugin])))
    }

    func profileService() -> ProfileService {
        return shared(ProfileServiceMoyaImpl(provider: MoyaProvider<ProfileAPI>(plugins: [networkPlugin, configurationPlugin, authPlugin])))
    }

    func yandexService() -> YandexService {
        return shared(YandexServiceMoyaImpl(provider: MoyaProvider<YandexAPI>(plugins: [networkPlugin])))
    }

    func documentsService() -> DocumentsService {
        return shared(DocumentsServiceImpl(provider: MoyaProvider<DocumentsAPI>(plugins: [networkPlugin, configurationPlugin])))
    }

    func rateService() -> RateService {
        return shared(RateServiceImpl(provider: MoyaProvider<RateAPI>(plugins: [networkPlugin, configurationPlugin, authPlugin])))
    }

    func pushNotificationsService() -> PushNotificationsService {
        return shared(PushNotificationsServiceMoyaImpl(provider: MoyaProvider<PushNotificationsAPI>(plugins: [networkPlugin, configurationPlugin, authPlugin])))
    }

    func paymentsService() -> PaymentsService {
        return shared(PaymentsServiceMoyaImpl(provider: MoyaProvider<PaymentsAPI>(plugins: [networkPlugin, configurationPlugin, authPlugin])))
    }

    func ordersHistoryService() -> OrdersHistoryService {
        return shared(OrdersHistoryServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, authPlugin, configurationPlugin])))
    }
}
