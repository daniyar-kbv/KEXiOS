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

    private let languagePlugin = LanguagePlugin(defaultStorage: DefaultStorageImpl.sharedStorage)

    private lazy var authProvider = MoyaProvider<AuthAPI>(plugins: [networkPlugin, languagePlugin])

    override init() {
        super.init()

        Single<Any>.authProvider = authProvider
    }

    func authService() -> AuthService {
        return shared(AuthServiceMoyaImpl(provider: authProvider))
    }

    func locationService() -> LocationService {
        return shared(LocationServiceMoyaImpl(provider: MoyaProvider<LocationAPI>(plugins: [networkPlugin, languagePlugin])))
    }

    func ordersService() -> OrdersService {
        return shared(OrdersServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, languagePlugin])))
    }

    func authorizedApplyService() -> AuthorizedApplyService {
        return shared(AuthorizedApplyServiceImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, languagePlugin, authPlugin])))
    }

    func menuService() -> MenuService {
        return shared(MenuServiceImpl(provider: MoyaProvider<MenuAPI>(plugins: [networkPlugin, languagePlugin])))
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

    func ordersHistoryService() -> OrdersHistoryService {
        return shared(OrdersHistoryServiceMoyaImpl(provider: MoyaProvider<OrdersAPI>(plugins: [networkPlugin, authPlugin])))
    }
}

/* Request sequences:
 * Update nomenclature DONE
    promotions
    nomenclature
 * Create address DONE
    authorized apply with address (needs auth)
    get user addresses (needs auth)
 * Change address DONE
    change user address (needs auth)
    authorized apply (needs auth)
    get user addresses (needs auth)
 * Authorization DONE
    otp verify
    get account info (needs auth)
    authorized apply with address (needs auth)
    update cart
    get user addresses (needs auth)
 * Delete address DONE
    delete address (needs auth)
    get addresses (needs auth)
 * Delete card DONE
    delete card (needs auth)
    get cards (needs auth)
 * Payment success DONE
    create order (needs auth)
    create payment (needs auth)
    authorized apply (needs auth)
 * Payment 3ds DONE
    create order (needs auth)
    create payment (needs auth)
    ------------------------
    confirm payment (needs auth)
    authorized apply (needs auth)
 */
