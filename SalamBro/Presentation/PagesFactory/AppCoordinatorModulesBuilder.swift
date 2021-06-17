//
//  AppCoordinatorModulesBuilder.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import UIKit // MARK: Tech debt, после изменения всех координаторов нужно импортить Foundation

protocol AppCoordinatorsModulesBuilder {
    func buildMenuCoordinator() -> MenuCoordinator
    func buildOnboardingCoordinator() -> OnBoardingCoordinator
    func buildProfileCoordinator(serviceComponents: ServiceComponents) -> ProfileCoordinator
    func makeSupportCoordinator(serviceComponents: ServiceComponents) -> SupportCoordinator
    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator
    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator
}

class AppCoordinatorsModulesBuilderImpl: AppCoordinatorsModulesBuilder {
    func buildMenuCoordinator() -> MenuCoordinator {
        return .init(navigationController: UINavigationController(), tabType: .menu)
    }

    func buildOnboardingCoordinator() -> OnBoardingCoordinator {
        return .init(router: MainRouter(),
                     pagesFactory: makeOnboardingPagesFactory())
    }

    private func makeOnboardingPagesFactory() -> OnBoadingPagesFactory {
        return OnBoardingPagesFactoryImpl()
    }

    func buildProfileCoordinator(serviceComponents: ServiceComponents) -> ProfileCoordinator {
        let router = MainRouter()
        return .init(router: router,
                     pagesFactory: makeProfilePagesFactory(serviceComponents: serviceComponents),
                     coordinatorsFactory: makeProfileChildCoordinatorsFactory(serviceComponents: serviceComponents,
                                                                              router: router))
    }

    private func makeProfilePagesFactory(serviceComponents: ServiceComponents) -> ProfilePagesFactory {
        return ProfilePagesFactoryImpl(serviceComponents: serviceComponents)
    }

    private func makeProfileChildCoordinatorsFactory(serviceComponents: ServiceComponents, router: Router) -> ProfileChildCoordinatorsFactory {
        return ProfileChildCoordinatorsFactoryImpl(serviceComponents: serviceComponents, router: router)
    }

    func makeSupportCoordinator(serviceComponents: ServiceComponents) -> SupportCoordinator {
        let router = MainRouter()
        return .init(router: router,
                     pagesFactory: makeSupportPagesFactory(serviceComponents: serviceComponents),
                     coordinatorsFactory: makeSupportCoordinatorsFactory(router: router, serviceComponents: serviceComponents))
    }

    private func makeSupportPagesFactory(serviceComponents: ServiceComponents) -> SupportPagesFactory {
        return SupportPagesFactoryImpl(serviceComponents: serviceComponents)
    }

    private func makeSupportCoordinatorsFactory(router: Router, serviceComponents: ServiceComponents) -> SupportCoordinatorsFactory {
        return SupportCoordinatorsFactoryImpl(router: router, serviceComponents: serviceComponents)
    }

    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator {
        return .init(router: MainRouter(),
                     pagesFactory: makeAuthPagesFactory(serviceComponents: serviceComponents,
                                                        repositoryComponents: repositoryComponents))
    }

    private func makeAuthPagesFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthPagesFactory {
        return AuthPagesFactoryImpl(serviceComponents: serviceComponents,
                                    repositoryComponents: repositoryComponents)
    }

    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator {
        let router = MainRouter()
        return .init(router: router,
                     pagesFactory: makeCartPagesFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents),
                     coordinatorsFactory: makeCartCoordinatorsFactory(router: router, serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    private func makeCartPagesFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartPagesFactory {
        return CartPagesFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)
    }

    private func makeCartCoordinatorsFactory(router: Router,
                                             serviceComponents: ServiceComponents,
                                             repositoryComponents: RepositoryComponents) -> CartCoordinatorsFactory
    {
        return CartCoordinatorsFactoryImpl(router: router, serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)
    }
}
