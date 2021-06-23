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

    private(set) var tabBarController: SBTabBarController!

    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let appCoordinatorsFactory: ApplicationCoordinatorFactory

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents,
         appCoordinatorsFactory: ApplicationCoordinatorFactory)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
        self.appCoordinatorsFactory = appCoordinatorsFactory
    }

    override func start() {
        tabBarController = SBTabBarController()

        configureMenuCoordinator()
        configureProfileCoordinator()
        configureSupportCoordinator()
        configureCartCoordinator()

        switchFlows()
    }

    private func switchFlows() {
        let locationRepository = repositoryComponents.makeLocationRepository()
        let brandRepository = repositoryComponents.makeBrandRepository()

        guard
            locationRepository.isAddressComplete(),
            brandRepository.getCurrentBrand() != nil
        else {
            startOnboardingFlow()
            return
        }

        showTabBarController()
    }

    private func configureMenuCoordinator() {
        let menuCoordinator = appCoordinatorsFactory.makeMenuCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        menuCoordinator.start()
        menuCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(title: L10n.MainTab.Menu.title,
                                                                                   image: Asset.menu.image,
                                                                                   selectedImage: Asset.menu.image)

        preparedViewControllers.append(menuCoordinator.router.getNavigationController())
        add(menuCoordinator)
    }

    private func configureProfileCoordinator() {
        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)
        profileCoordinator.start()
        profileCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(title: L10n.MainTab.Profile.title,
                                                                                      image: Asset.profile.image,
                                                                                      selectedImage: Asset.profile.image)
        preparedViewControllers.append(profileCoordinator.router.getNavigationController())
        add(profileCoordinator)
    }

    private func configureSupportCoordinator() {
        let supportCoordinator = appCoordinatorsFactory.makeSupportCoordinator(serviceComponents: serviceComponents)
        supportCoordinator.start()
        supportCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(title: L10n.MainTab.Support.title,
                                                                                      image: Asset.support.image,
                                                                                      selectedImage: Asset.support.image)
        preparedViewControllers.append(supportCoordinator.router.getNavigationController())
        add(supportCoordinator)
    }

    private func configureCartCoordinator() {
        let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents,
                                                                         repositoryComponents: repositoryComponents)
        cartCoordinator.start()
        cartCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(title: L10n.MainTab.Cart.title,
                                                                                   image: Asset.cart.image,
                                                                                   selectedImage: Asset.cart.image)
        preparedViewControllers.append(cartCoordinator.router.getNavigationController())
        add(cartCoordinator)
    }

    private func startOnboardingFlow() {
        let onboardingCoordinator = appCoordinatorsFactory.makeOnboardingCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        add(onboardingCoordinator)
        onboardingCoordinator.didFinish = { [weak self, weak onboardingCoordinator] in
            self?.remove(onboardingCoordinator)
            onboardingCoordinator = nil
            self?.showTabBarController()
        }

        onboardingCoordinator.start()
    }

    private func showTabBarController() {
        tabBarController.viewControllers = preparedViewControllers

        UIApplication.shared.setRootView(tabBarController) // MARK: Tech debt
    }
}
