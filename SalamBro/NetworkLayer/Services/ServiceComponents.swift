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
    func citiesService() -> CitiesService
}

final class ServiceComponentsAssembly: DependencyFactory, ServiceComponents {
    // MARK: Network logger

    private let networkPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))

    // MARK: Auth Plugin for authorized requests

    private let authPlugin = AuthPlugin()

    func authService() -> AuthService {
        return shared(AuthServiceMoyaImpl(provider: MoyaProvider<AuthAPI>(plugins: [networkPlugin])))
    }

    func locationService() -> LocationService {
        return shared(LocationServiceMoyaImpl(provider: MoyaProvider<LocationAPI>(plugins: [networkPlugin])))
    }

    func ordersService() -> OrdersService {
        return shared(OrdersServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin])))
    }

    func promotionsService() -> PromotionsService {
        return shared(PromotionsServiceImpl(provider: MoyaProvider<PromotionsAPI>(plugins: [networkPlugin])))
    }

    func profileService() -> ProfileService {
        return shared(ProfileServiceMoyaImpl(provider: MoyaProvider<ProfileAPI>(plugins: [networkPlugin, authPlugin])))
    }

    func documentsService() -> DocumentsService {
        return shared(DocumentsServiceImpl(provider: MoyaProvider<DocumentsAPI>(plugins: [networkPlugin])))
    }

    func citiesService() -> CitiesService {
        return shared(CitiesServiceMoyaImpl(provider: MoyaProvider<CitiesAPI>(plugins: [networkPlugin, authPlugin])))
    }
}
