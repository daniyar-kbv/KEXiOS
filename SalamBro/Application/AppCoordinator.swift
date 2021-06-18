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

        restartAuthCoordinator = { [weak self] in
            self?.startAuthCoordinator()
        }

        configureProfileCoordinator()
        configureCartCoordinator()

        // MARK: Нужно тут прописать конфиги для Меню, Помощи и Корзины

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

    private func configureCartCoordinator() {
        let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents,
                                                                         repositoryComponents: repositoryComponents)
        cartCoordinator.start()
        cartCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(title: L10n.MainTab.Cart.title,
                                                                                   image: Asset.cart.image,
                                                                                   selectedImage: Asset.cart.image)
        preparedViewControllers.append(cartCoordinator.router.getNavigationController())
        add(cartCoordinator)
        navigationControllers.append(cartCoordinator.router.getNavigationController())
    }

    private func startAuthCoordinator() {
        let authCoordinator = appCoordinatorsFactory.makeAuthCoordinator(serviceComponents: serviceComponents,
                                                                         repositoryComponents: repositoryComponents)

        add(authCoordinator)
        authCoordinator.didFinish = { [weak self, weak authCoordinator] in
            self?.remove(authCoordinator)
            authCoordinator = nil
        }

        authCoordinator.start()
    }

    private func startOnboardingFlow() {
        let onboardingCoordinator = appCoordinatorsFactory.makeOnboardingCoordinator()

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
