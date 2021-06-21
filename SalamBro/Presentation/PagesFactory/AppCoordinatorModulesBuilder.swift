//
//  AppCoordinatorModulesBuilder.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import UIKit // MARK: Tech debt, после изменения всех координаторов нужно импортить Foundation

protocol AppCoordinatorsModulesBuilder {
    func buildMenuCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> MenuCoordinator
    func buildOnboardingCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> OnBoardingCoordinator
    func buildProfileCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfileCoordinator
    func makeSupportCoordinator(serviceComponents: ServiceComponents) -> SupportCoordinator
    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator
    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator
}

class AppCoordinatorsModulesBuilderImpl: AppCoordinatorsModulesBuilder {
    func buildMenuCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> MenuCoordinator {
        let router = MainRouter()
        return .init(router: router,
                     serviceComponents: serviceComponents, repositoryComponents: repositoryComponents,
                     pagesFactory: makeMenuPagesFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents),
                     coordinatorsFactory: makeMenuCoordinatorsFactory(router: router))
    }

    private func makeMenuPagesFactory(serviceComponents: ServiceComponents,
                                      repositoryComponents: RepositoryComponents) -> MenuPagesFactory
    {
        return MenuPagesFactoryIml(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)
    }

    private func makeMenuCoordinatorsFactory(router: Router) -> MenuCoordinatorsFactory {
        return MenuCoordinatorsFactoryImpl(router: router)
    }

    func buildOnboardingCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> OnBoardingCoordinator {
        return .init(router: MainRouter(),
                     pagesFactory: makeOnboardingPagesFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    private func makeOnboardingPagesFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> OnBoadingPagesFactory {
        return OnBoardingPagesFactoryImpl(serviceComponents: serviceComponents,
                                          repositoryComponents: repositoryComponents)
    }

    func buildProfileCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfileCoordinator {
        let router = MainRouter()
        return .init(router: router,
                     pagesFactory: makeProfilePagesFactory(serviceComponents: serviceComponents),
                     coordinatorsFactory: makeProfileChildCoordinatorsFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, router: router))
    }

    private func makeProfilePagesFactory(serviceComponents: ServiceComponents) -> ProfilePagesFactory {
        return ProfilePagesFactoryImpl(serviceComponents: serviceComponents)
    }

    private func makeProfileChildCoordinatorsFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, router: Router) -> ProfileChildCoordinatorsFactory {
        return ProfileChildCoordinatorsFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, router: router)
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
