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
}

final class ProfileChildCoordinatorsFactoryImpl: DependencyFactory, ProfileChildCoordinatorsFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let router: Router

    init(serviceComponents: ServiceComponents, router: Router) {
        self.serviceComponents = serviceComponents
        repositoryComponents = repositoryComponents
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
}
