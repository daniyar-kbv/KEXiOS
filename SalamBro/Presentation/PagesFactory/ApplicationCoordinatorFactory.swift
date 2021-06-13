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
        return scoped(.init(navigationController: UINavigationController(),
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
        return scoped(.init(router: MainRouter(),
                            pagesFactory: makeProfilePagesFactory(serviceComponents: serviceComponents)))
    }

    private func makeProfilePagesFactory(serviceComponents: ServiceComponents) -> ProfilePagesFactory {
        return scoped(ProfilePagesFactoryImpl(serviceComponents: serviceComponents))
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
