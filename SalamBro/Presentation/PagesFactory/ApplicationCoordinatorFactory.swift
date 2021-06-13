//
//  ApplicationCoordinatorFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol ApplicationCoordinatorFactory: AnyObject {
    func makeMenuCoordinator() -> MenuCoordinator
    func makeOnboardingCoordinator() -> OnBoardingCoordinator
    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator
    func makeCartCoordinator() -> CartCoordinator
    func makeProfileCoordinator(serviceComponents: ServiceComponents) -> ProfileCoordinator
}

final class ApplicationCoordinatorFactoryImpl: DependencyFactory, ApplicationCoordinatorFactory {
    func makeMenuCoordinator() -> MenuCoordinator {
        return shared(.init(navigationController: UINavigationController(),
                            tabType: .menu))
    }

    func makeOnboardingCoordinator() -> OnBoardingCoordinator {
        return scoped(.init(router: MainRouter(),
                            pagesFactory: makeOnboardingPagesFactory()))
    }

    private func makeOnboardingPagesFactory() -> OnBoadingPagesFactory {
        return scoped(OnBoardingPagesFactoryImpl())
    }

    func makeProfileCoordinator(serviceComponents: ServiceComponents) -> ProfileCoordinator {
        let router = MainRouter()
        return shared(.init(router: router,
                            pagesFactory: makeProfilePagesFactory(serviceComponents: serviceComponents),
                            coordinatorsFactory: makeProfileChildCoordinatorsFactory(serviceComponents: serviceComponents,
                                                                                     router: router)))
    }

    private func makeProfilePagesFactory(serviceComponents: ServiceComponents) -> ProfilePagesFactory {
        return shared(ProfilePagesFactoryImpl(serviceComponents: serviceComponents))
    }

    private func makeProfileChildCoordinatorsFactory(serviceComponents: ServiceComponents, router: Router) -> ProfileChildCoordinatorsFactory {
        return shared(ProfileChildCoordinatorsFactoryImpl(serviceComponents: serviceComponents, router: router))
    }

    func makeCartCoordinator() -> CartCoordinator {
        return scoped(.init(navigationController: UINavigationController(),
                            tabType: .cart))
    }

    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator {
        return scoped(.init(router: MainRouter(),
                            pagesFactory: makeAuthPagesFactory(serviceComponents: serviceComponents,
                                                               repositoryComponents: repositoryComponents)))
    }

    private func makeAuthPagesFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthPagesFactory {
        return scoped(AuthPagesFactoryImpl(serviceComponents: serviceComponents,
                                           repositoryComponents: repositoryComponents))
    }
}
