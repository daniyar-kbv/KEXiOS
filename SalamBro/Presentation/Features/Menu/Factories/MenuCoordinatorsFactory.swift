//
//  MenuCoordinatorsFactory.swift
//  SalamBro
//
//  Created by Dan on 6/19/21.
//

import Foundation

protocol MenuCoordinatorsFactory {
    func makeAddressCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, flowType: AddressCoordinator.FlowType) -> AddressCoordinator
    func makeMenuDetailCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, positionUUID: String) -> MenuDetailCoordinator
    func makeAuthCoordinator() -> AuthCoordinator
}

class MenuCoordinatorsFactoryImpl: DependencyFactory, MenuCoordinatorsFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let router: Router

    init(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, router: Router) {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
        self.router = router
    }

    func makeAddressCoordinator(serviceComponents: ServiceComponents,
                                repositoryComponents: RepositoryComponents,
                                flowType: AddressCoordinator.FlowType) -> AddressCoordinator
    {
        return scoped(.init(router: router,
                            pagesFactory: makeAddressPageFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents),
                            flowType: flowType))
    }

    private func makeAddressPageFactory(serviceComponents _: ServiceComponents,
                                        repositoryComponents: RepositoryComponents) -> AddressPagesFactory
    {
        return scoped(AddressPagesFactoryImpl(repositoryComponents: repositoryComponents))
    }

    func makeMenuDetailCoordinator(serviceComponents: ServiceComponents,
                                   repositoryComponents: RepositoryComponents,
                                   positionUUID: String) -> MenuDetailCoordinator
    {
        return scoped(.init(router: router,
                            serviceComponents: serviceComponents,
                            pagesFactory: makeMenuDetailPageFactory(serviceComponents: serviceComponents,
                                                                    repositoryComponents: repositoryComponents),
                            positionUUID: positionUUID))
    }

    private func makeMenuDetailPageFactory(serviceComponents: ServiceComponents,
                                           repositoryComponents: RepositoryComponents) -> MenuDetailPagesFactory
    {
        return scoped(MenuDetailPagesFactoryImpl(serviceComponents: serviceComponents,
                                                 repositoryComponents: repositoryComponents))
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
