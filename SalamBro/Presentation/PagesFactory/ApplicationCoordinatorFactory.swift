//
//  ApplicationCoordinatorFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol ApplicationCoordinatorFactory: AnyObject {
    func makeOnboardingCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> OnBoardingCoordinator
    func makeMenuCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> MenuCoordinator
    func makeAuthCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> AuthCoordinator
    func makeCartCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> CartCoordinator
    func makeProfileCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfileCoordinator
    func makeSupportCoordinator(serviceComponents: ServiceComponents) -> SupportCoordinator
}

final class ApplicationCoordinatorFactoryImpl: DependencyFactory, ApplicationCoordinatorFactory {
    private let builder: AppCoordinatorsModulesBuilder

    init(builder: AppCoordinatorsModulesBuilder) {
        self.builder = builder
    }

    func makeOnboardingCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> OnBoardingCoordinator {
        return scoped(builder.buildOnboardingCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    func makeMenuCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> MenuCoordinator {
        return shared(builder.buildMenuCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
    }

    func makeProfileCoordinator(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) -> ProfileCoordinator {
        return shared(builder.buildProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents))
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
