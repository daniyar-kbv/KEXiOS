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
    // Network logger
    private let networkPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))

    // Auth Plugin for authorized requests
    private let authPlugin = AuthPlugin(authTokenStorage: AuthTokenStorageImpl.sharedStorage)

    // Language Plugin to pass language code to headers
    private let configurationPlugin = ConfigurationPlugin(defaultStorage: DefaultStorageImpl.sharedStorage)

    // Plugin for iOS network error processing
    private let networkErrorPlugin = NetworkErrorPlugin()

    private lazy var defaultPlugins: [PluginType] = [networkPlugin, configurationPlugin, networkErrorPlugin]

    private lazy var authProvider = MoyaProvider<AuthAPI>(plugins: defaultPlugins)
    private lazy var pushNotificationsProvider = MoyaProvider<PushNotificationsAPI>(plugins: defaultPlugins + [authPlugin])
    private lazy var ordersProvider = MoyaProvider<OrdersAPI>(plugins: defaultPlugins)
    private lazy var authApplyProvider = MoyaProvider<OrdersAPI>(plugins: defaultPlugins + [authPlugin])

    override init() {
        super.init()

        Single<Any>.authProvider = authProvider
        Single<Any>.pushNotificationsProvider = pushNotificationsProvider
        Single<Any>.ordersProvider = ordersProvider
        Single<Any>.authApplyProvider = authApplyProvider
    }

    func authService() -> AuthService {
        return shared(AuthServiceMoyaImpl(provider: authProvider))
    }

    func locationService() -> LocationService {
        return shared(LocationServiceMoyaImpl(provider: MoyaProvider<LocationAPI>(plugins: defaultPlugins)))
    }

    func ordersService() -> OrdersService {
        return shared(OrdersServiceMoyaImpl(provider: ordersProvider))
    }

    func authorizedApplyService() -> AuthorizedApplyService {
        return shared(AuthorizedApplyServiceImpl(provider: authApplyProvider))
    }

    func menuService() -> MenuService {
        return shared(MenuServiceImpl(provider: MoyaProvider<MenuAPI>(plugins: defaultPlugins)))
    }

    func profileService() -> ProfileService {
        return shared(ProfileServiceMoyaImpl(provider: MoyaProvider<ProfileAPI>(plugins: defaultPlugins + [authPlugin])))
    }

    func yandexService() -> YandexService {
        return shared(YandexServiceMoyaImpl(provider: MoyaProvider<YandexAPI>(plugins: [networkPlugin])))
    }

    func documentsService() -> DocumentsService {
        return shared(DocumentsServiceImpl(provider: MoyaProvider<DocumentsAPI>(plugins: defaultPlugins)))
    }

    func rateService() -> RateService {
        return shared(RateServiceImpl(provider: MoyaProvider<RateAPI>(plugins: defaultPlugins + [authPlugin])))
    }

    func pushNotificationsService() -> PushNotificationsService {
        return shared(PushNotificationsServiceMoyaImpl(provider: pushNotificationsProvider))
    }

    func paymentsService() -> PaymentsService {
        return shared(PaymentsServiceMoyaImpl(provider: MoyaProvider<PaymentsAPI>(plugins: defaultPlugins + [authPlugin])))
    }

    func ordersHistoryService() -> OrdersHistoryService {
        return shared(OrdersHistoryServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: defaultPlugins + [authPlugin])))
    }
}
