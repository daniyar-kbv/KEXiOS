//
//  AppCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    private var preparedViewControllers: [UIViewController] = []
    private var navigationControllers = [UINavigationController]()
    private var restartAuthCoordinator: (() -> Void)?

    private(set) var tabBarController: SBTabBarController!

    private let serviceComponents: ServiceComponents
    private let appCoordinatorsFactory: ApplicationCoordinatorFactory

    private let locationRepository: LocationRepository // FIXME: Tech debt
    private let brandRepository: BrandRepository // FIXME: Tech debt

    init(serviceComponents: ServiceComponents,
         appCoordinatorsFactory: ApplicationCoordinatorFactory,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository)
    {
        self.serviceComponents = serviceComponents
        self.appCoordinatorsFactory = appCoordinatorsFactory
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
    }

    override func start() {
        tabBarController = SBTabBarController()

        restartAuthCoordinator = { [weak self] in
            self?.startAuthCoordinator()
        }

        configureProfileCoordinator()

        if locationRepository.isAddressComplete(),
           brandRepository.getCurrentBrand() != nil
        {
            showTabBarController()
        } else {
            startOnboardingFlow()
        }
    }

    private func configureProfileCoordinator() {
        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents)
        profileCoordinator.start()
        profileCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(title: L10n.MainTab.Profile.title,
                                                                                      image: Asset.profile.image,
                                                                                      selectedImage: Asset.profile.image)
        preparedViewControllers.append(profileCoordinator.router.getNavigationController())
        add(profileCoordinator)
        navigationControllers.append(profileCoordinator.router.getNavigationController())
    }

    private func startAuthCoordinator() {
        let authCoordinator = appCoordinatorsFactory.makeAuthCoordinator()

        add(authCoordinator)
        authCoordinator.didFinish = { [weak self] in
            self?.remove(authCoordinator)
        }

        authCoordinator.start()
    }

    private func startOnboardingFlow() {
        let onboardingCoordinator = appCoordinatorsFactory.makeOnboardingCoordinator()

        add(onboardingCoordinator)
        onboardingCoordinator.didFinish = { [weak self] in
            self?.remove(onboardingCoordinator)
            self?.showTabBarController()
        }

        onboardingCoordinator.start()
    }

    private func showTabBarController() {
        tabBarController.viewControllers = preparedViewControllers
        UIApplication.shared.setRootView(tabBarController)
    }
}
