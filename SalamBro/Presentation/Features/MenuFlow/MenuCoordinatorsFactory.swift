//
//  MenuCoordinatorsFactory.swift
//  SalamBro
//
//  Created by Dan on 6/19/21.
//

import Foundation

protocol MenuCoordinatorsFactory {
    func makeAddressCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, flowType: AddressCoordinator.FlowType) -> AddressCoordinator
    func makePromotionsCoordinator(promotionURL: URL, infoURL: URL?) -> PromotionsCoordinator
    func makeMenuDetailCoordinator(serviceComponents: ServiceComponents, positionUUID: String) -> MenuDetailCoordinator
}

class MenuCoordinatorsFactoryImpl: DependencyFactory, MenuCoordinatorsFactory {
    private let router: Router

    init(router: Router) {
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

    private func makeAddressPageFactory(serviceComponents: ServiceComponents,
                                        repositoryComponents: RepositoryComponents) -> AddressPagesFactory
    {
        return scoped(AddressPagesFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    func makePromotionsCoordinator(promotionURL: URL, infoURL: URL?) -> PromotionsCoordinator {
        return scoped(.init(router: router,
                            pagesFactory: makePromotionsPageFactory(),
                            promotionURL: promotionURL,
                            infoURL: infoURL))
    }

    private func makePromotionsPageFactory() -> PromotionsPagesFactory {
        return scoped(PromotionsPagesFactoryImpl())
    }

    func makeMenuDetailCoordinator(serviceComponents: ServiceComponents, positionUUID: String) -> MenuDetailCoordinator {
        return scoped(.init(router: router,
                            serviceComponents: serviceComponents,
                            pagesFactory: makeMenuDetailPageFactory(serviceComponents: serviceComponents),
                            positionUUID: positionUUID))
    }

    private func makeMenuDetailPageFactory(serviceComponents: ServiceComponents) -> MenuDetailPagesFactory {
        return scoped(MenuDetailPagesFactoryImpl(serviceComponents: serviceComponents))
    }
}
