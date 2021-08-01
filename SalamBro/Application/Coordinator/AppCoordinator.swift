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

    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let appCoordinatorsFactory: ApplicationCoordinatorFactory
    private let pagesFactory: ApplicationPagesFactory

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents,
         appCoordinatorsFactory: ApplicationCoordinatorFactory,
         pagesFactory: ApplicationPagesFactory)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
        self.appCoordinatorsFactory = appCoordinatorsFactory
        self.pagesFactory = pagesFactory
    }

    override func start() {
        configureMenuCoordinator()
        configureProfileCoordinator()
        configureSupportCoordinator()
        configureCartCoordinator()

        switchFlows()
    }

    private func switchFlows() {
        let locationRepository = repositoryComponents.makeAddressRepository()
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
        menuCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(
            title: SBLocalization.localized(key: TabBarText.menuTitle),
            image: SBImageResource.getIcon(for: TabBarIcon.menu),
            selectedImage: SBImageResource.getIcon(for: TabBarIcon.menu)
        )

        preparedViewControllers.append(menuCoordinator.router.getNavigationController())
        add(menuCoordinator)
    }

    private func configureProfileCoordinator() {
        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.onLanguageChange = { [weak self] in
            self?.restartApp()
        }

        profileCoordinator.start()
        profileCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(
            title: SBLocalization.localized(key: TabBarText.profileTitle),
            image: SBImageResource.getIcon(for: TabBarIcon.profile),
            selectedImage: SBImageResource.getIcon(for: TabBarIcon.profile)
        )

        preparedViewControllers.append(profileCoordinator.router.getNavigationController())
        add(profileCoordinator)
    }

    private func configureSupportCoordinator() {
        let supportCoordinator = appCoordinatorsFactory.makeSupportCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        supportCoordinator.start()
        supportCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(
            title: SBLocalization.localized(key: TabBarText.supportTitle),
            image: SBImageResource.getIcon(for: TabBarIcon.support),
            selectedImage: SBImageResource.getIcon(for: TabBarIcon.support)
        )

        preparedViewControllers.append(supportCoordinator.router.getNavigationController())
        add(supportCoordinator)
    }

    private func configureCartCoordinator() {
        let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents,
                                                                         repositoryComponents: repositoryComponents)
        cartCoordinator.start()
        cartCoordinator.router.getNavigationController().tabBarItem = UITabBarItem(
            title: SBLocalization.localized(key: TabBarText.cartTitle),
            image: SBImageResource.getIcon(for: TabBarIcon.cart),
            selectedImage: SBImageResource.getIcon(for: TabBarIcon.cart)
        )

        cartCoordinator.toMenu = { [weak self] in
            self?.pagesFactory.makeSBTabbarController().selectedIndex = 0
        }

        cartCoordinator.toOrderHistory = { [weak self] in
            self?.pagesFactory.makeSBTabbarController().selectedIndex = 1

            guard let serviceComponents = self?.serviceComponents,
                  let repositoryComponents = self?.repositoryComponents else { return }

            let profileCoordinator = self?.appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

            profileCoordinator?.showOrderHistoryPage()
        }

        preparedViewControllers.append(cartCoordinator.router.getNavigationController())
        add(cartCoordinator)
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
        pagesFactory.makeSBTabbarController().viewControllers = preparedViewControllers

        UIApplication.shared.setRootView(pagesFactory.makeSBTabbarController()) // MARK: Tech debt
    }
}

// MARK: - App Restart

extension AppCoordinator {
    func restartApp() {
        restartMenuCoordinator()
        restartProfileCoordinator()
        restartSupportCoordinator()
        restartCartCoordinator()
    }

    private func restartMenuCoordinator() {
        let menuCoordinator = appCoordinatorsFactory.makeMenuCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        menuCoordinator.restart()
    }

    private func restartProfileCoordinator() {
        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.restart()
    }

    private func restartSupportCoordinator() {
        let supportCoordinator = appCoordinatorsFactory.makeSupportCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        supportCoordinator.restart()
    }

    private func restartCartCoordinator() {
        let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        cartCoordinator.restart()
    }
}

// MARK: - Notifications handling

extension AppCoordinator {
    func handleNotification(pushNotification: PushNotification) {
        switch pushNotification.pushType {
        case .info:
            break
        case .promotions:
            openPromotion(pushNotification: pushNotification)
        case .orderRate:
            openRateOrder(pushNotification: pushNotification)
        case .orderStatusUpdate:
            openOrderHistory()
        }
    }

    private func openPromotion(pushNotification: PushNotification) {
        pagesFactory.makeSBTabbarController().selectedIndex = 0
        let menuCoordinator = appCoordinatorsFactory.makeMenuCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        guard let url = URL(
            string: String(
                format: Constants.URLs.promotionURL, pushNotification.pushTypeValue
            )
        )
        else { return }

        menuCoordinator.openPromotion(promotionURL: url, name: nil)
    }

    private func openRateOrder(pushNotification _: PushNotification) {
        pagesFactory.makeSBTabbarController().selectedIndex = 2

        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.showOrderHistoryPage()

        let orderHistoryCoordinator = profileCoordinator.childCoordinators.first(where: { $0 is OrderHistoryCoordinator }) as! OrderHistoryCoordinator

        orderHistoryCoordinator.showRateOrderPage()
    }

    private func openOrderHistory() {
        pagesFactory.makeSBTabbarController().selectedIndex = 2

        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.showOrderHistoryPage()
    }
}
