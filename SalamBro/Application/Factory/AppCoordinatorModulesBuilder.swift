//
//  AppCoordinatorModulesBuilder.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import Foundation

protocol AppCoordinatorsModulesBuilder {
    func buildMenuCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> MenuCoordinator
    func buildOnboardingCoordinator(repositoryComponents: RepositoryComponents) -> OnBoardingCoordinator
    func buildProfileCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfileCoordinator
    func makeSupportCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> SupportCoordinator
    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator
    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator
}

final class AppCoordinatorsModulesBuilderImpl: AppCoordinatorsModulesBuilder {
    private let routersFactory: RoutersFactory

    init(routersFactory: RoutersFactory) {
        self.routersFactory = routersFactory
    }

    func buildMenuCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> MenuCoordinator {
        let router = routersFactory.makeMenuRouter()
        return .init(router: router,
                     serviceComponents: serviceComponents, repositoryComponents: repositoryComponents,
                     pagesFactory: makeMenuPagesFactory(repositoryComponents: repositoryComponents),
                     coordinatorsFactory: makeMenuCoordinatorsFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, router: router))
    }

    private func makeMenuPagesFactory(repositoryComponents: RepositoryComponents) -> MenuPagesFactory
    {
        return MenuPagesFactoryIml(repositoryComponents: repositoryComponents)
    }

    private func makeMenuCoordinatorsFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, router: Router) -> MenuCoordinatorsFactory {
        return MenuCoordinatorsFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, router: router)
    }

    func buildOnboardingCoordinator(repositoryComponents: RepositoryComponents) -> OnBoardingCoordinator {
        return .init(router: routersFactory.makeOnboardingRouter(),
                     pagesFactory: makeOnboardingPagesFactory(repositoryComponents: repositoryComponents))
    }

    private func makeOnboardingPagesFactory(repositoryComponents: RepositoryComponents) -> OnBoadingPagesFactory {
        return OnBoardingPagesFactoryImpl(repositoryComponents: repositoryComponents)
    }

    func buildProfileCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfileCoordinator {
        let router = routersFactory.makeProfileRouter()
        return .init(router: router,
                     pagesFactory: makeProfilePagesFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents),
                     coordinatorsFactory: makeProfileChildCoordinatorsFactory(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, router: router))
    }

    private func makeProfilePagesFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfilePagesFactory {
        return ProfilePagesFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)
    }

    private func makeProfileChildCoordinatorsFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents, router: Router) -> ProfileChildCoordinatorsFactory {
        return ProfileChildCoordinatorsFactoryImpl(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, router: router)
    }

    func makeSupportCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> SupportCoordinator {
        let router = routersFactory.makeSupportRouter()
        return .init(router: router,
                     pagesFactory: makeSupportPagesFactory(repositoryComponents: repositoryComponents),
                     coordinatorsFactory: makeSupportCoordinatorsFactory(router: router, serviceComponents: serviceComponents))
    }

    private func makeSupportPagesFactory(repositoryComponents: RepositoryComponents) -> SupportPagesFactory {
        return SupportPagesFactoryImpl(repositoryComponents: repositoryComponents)
    }

    private func makeSupportCoordinatorsFactory(router: Router, serviceComponents: ServiceComponents) -> SupportCoordinatorsFactory {
        return SupportCoordinatorsFactoryImpl(router: router, serviceComponents: serviceComponents)
    }

    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator {
        return .init(router: routersFactory.makeAuthRouter(),
                     pagesFactory: makeAuthPagesFactory(serviceComponents: serviceComponents,
                                                        repositoryComponents: repositoryComponents))
    }

    private func makeAuthPagesFactory(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthPagesFactory {
        return AuthPagesFactoryImpl(serviceComponents: serviceComponents,
                                    repositoryComponents: repositoryComponents)
    }

    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator {
        let router = routersFactory.makeCartRouter()
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
