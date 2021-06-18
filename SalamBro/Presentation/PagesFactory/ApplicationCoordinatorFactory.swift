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
    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator
    func makeProfileCoordinator(serviceComponents: ServiceComponents) -> ProfileCoordinator
    func makeSupportCoordinator(serviceComponents: ServiceComponents) -> SupportCoordinator
}

final class ApplicationCoordinatorFactoryImpl: DependencyFactory, ApplicationCoordinatorFactory {
    private let builder: AppCoordinatorsModulesBuilder

    init(builder: AppCoordinatorsModulesBuilder) {
        self.builder = builder
    }

    func makeMenuCoordinator() -> MenuCoordinator {
        return shared(builder.buildMenuCoordinator())
    }

    func makeOnboardingCoordinator() -> OnBoardingCoordinator {
        return scoped(builder.buildOnboardingCoordinator())
    }

    func makeProfileCoordinator(serviceComponents: ServiceComponents) -> ProfileCoordinator {
        return shared(builder.buildProfileCoordinator(serviceComponents: serviceComponents))
    }

    func makeSupportCoordinator(serviceComponents: ServiceComponents) -> SupportCoordinator {
        return shared(builder.makeSupportCoordinator(serviceComponents: serviceComponents))
    }

    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator {
        return shared(builder.makeCartCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator {
        return scoped(builder.makeAuthCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }
}
