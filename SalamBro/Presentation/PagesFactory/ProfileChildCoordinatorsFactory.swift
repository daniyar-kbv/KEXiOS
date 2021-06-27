//
//  ProfileChildCoordinatorsFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 14.06.2021.
//

import Foundation

protocol ProfileChildCoordinatorsFactory: AnyObject {
    func makeAddressListCoordinator() -> AddressListCoordinator
    func makeOrderCoordinator() -> OrderHistoryCoordinator
    func makeAuthCoordinator() -> AuthCoordinator
}

final class ProfileChildCoordinatorsFactoryImpl: DependencyFactory, ProfileChildCoordinatorsFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let router: Router

    init(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, router: Router) {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
        self.router = router
    }

    func makeAddressListCoordinator() -> AddressListCoordinator {
        return AddressListCoordinator(router: router,
                                      pagesFactory: AddressListPagesFactoryImpl(repositoryComponents: repositoryComponents))
    }

    func makeOrderCoordinator() -> OrderHistoryCoordinator {
        return OrderHistoryCoordinator(router: router,
                                       pagesFactory: OrderHistoryPagesFactoryImpl())
    }

    func makeAuthCoordinator() -> AuthCoordinator {
        return scoped(.init(router: router,
                            pagesFactory: makeAuthPagesFactory()))
    }

    private func makeAuthPagesFactory() -> AuthPagesFactory {
        return scoped(AuthPagesFactoryImpl(serviceComponents: serviceComponents,
                                           repositoryComponents: repositoryComponents))
    }
}
