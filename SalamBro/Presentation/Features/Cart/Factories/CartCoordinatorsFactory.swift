//
//  CartCoordinatorsFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 14.06.2021.
//

import Foundation

protocol CartCoordinatorsFactory: AnyObject {
    func makeAuthCoordinator() -> AuthCoordinator
    func makePaymentCoordinator() -> PaymentCoordinator
}

final class CartCoordinatorsFactoryImpl: DependencyFactory, CartCoordinatorsFactory {
    private let router: Router
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(router: Router,
         serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents)
    {
        self.router = router
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeAuthCoordinator() -> AuthCoordinator {
        return scoped(.init(router: router,
                            pagesFactory: makeAuthPagesFactory()))
    }

    private func makeAuthPagesFactory() -> AuthPagesFactory {
        return scoped(AuthPagesFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    func makePaymentCoordinator() -> PaymentCoordinator {
        return scoped(.init(router: router, pagesFactory: makePaymentPagesFactory()))
    }

    private func makePaymentPagesFactory() -> PaymentPagesFactory {
        return scoped(PaymentPagesFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }
}
