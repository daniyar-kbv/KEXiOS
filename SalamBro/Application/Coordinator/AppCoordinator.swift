//
//  AppCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class AppCoordinator: BaseCoordinator {
    private let tabBarBarTypes: [SBTabBarType] = [.menu, .profile, .support, .cart]
    private var preparedViewControllers: [UIViewController] = []

    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let appCoordinatorsFactory: ApplicationCoordinatorFactory
    private let pagesFactory: ApplicationPagesFactory

    private let disposeBag = DisposeBag()

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
        configureCoordinators()
        switchFlows()
    }

    private func switchFlows() {
        guard DefaultStorageImpl.sharedStorage.notFirstLaunch else {
            AuthTokenStorageImpl.sharedStorage.cleanUp()
            startOnboardingFlow()
            return
        }

        showTabBarController()
    }

    private func configureCoordinators() {
        tabBarBarTypes.forEach { type in
            switch type {
            case .menu: configureMenuCoordinator(tabBarItem: type.tabBarItem)
            case .profile: configureProfileCoordinator(tabBarItem: type.tabBarItem)
            case .support: configureSupportCoordinator(tabBarItem: type.tabBarItem)
            case .cart: configureCartCoordinator(tabBarItem: type.tabBarItem)
            }
        }
    }

    private func configureMenuCoordinator(tabBarItem: UITabBarItem) {
        let menuCoordinator = appCoordinatorsFactory.makeMenuCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        menuCoordinator.start()
        menuCoordinator.router.getNavigationController().tabBarItem = tabBarItem

        preparedViewControllers.append(menuCoordinator.router.getNavigationController())
        add(menuCoordinator)
    }

    private func configureProfileCoordinator(tabBarItem: UITabBarItem) {
        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.onLanguageChange = { [weak self] in
            self?.restartApp()
        }

        profileCoordinator.toMenu = { [weak self] in
            guard let tabIndex = self?.tabBarBarTypes.firstIndex(of: .menu) else { return }
            self?.pagesFactory.makeSBTabbarController().selectedIndex = tabIndex
        }

        profileCoordinator.start()
        profileCoordinator.router.getNavigationController().tabBarItem = tabBarItem

        preparedViewControllers.append(profileCoordinator.router.getNavigationController())
        add(profileCoordinator)
    }

    private func configureSupportCoordinator(tabBarItem: UITabBarItem) {
        let supportCoordinator = appCoordinatorsFactory.makeSupportCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        supportCoordinator.start()
        supportCoordinator.router.getNavigationController().tabBarItem = tabBarItem

        preparedViewControllers.append(supportCoordinator.router.getNavigationController())
        add(supportCoordinator)
    }

    private func configureCartCoordinator(tabBarItem: UITabBarItem) {
        let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents,
                                                                         repositoryComponents: repositoryComponents)
        cartCoordinator.start()
        cartCoordinator.router.getNavigationController().tabBarItem = tabBarItem

        configCartTabBarItem(cartCoordinator: cartCoordinator)

        cartCoordinator.toMenu = { [weak self] in
            guard let tabIndex = self?.tabBarBarTypes.firstIndex(of: .menu) else { return }
            self?.pagesFactory.makeSBTabbarController().selectedIndex = tabIndex
        }

        cartCoordinator.toOrderHistory = openOrderHistory

        preparedViewControllers.append(cartCoordinator.router.getNavigationController())
        add(cartCoordinator)
    }

    private func configCartTabBarItem(cartCoordinator: CartCoordinator) {
        let cartRepository = repositoryComponents.makeCartRepository()

        cartCoordinator.router.getNavigationController().tabBarItem.badgeColor = .kexRed
        cartCoordinator.router.getNavigationController().tabBarItem.badgeValue = cartRepository.getLocalCart().getBadgeCount()

        cartRepository.outputs.didChange
            .subscribe(onNext: { [weak cartCoordinator] cartInfo in
                cartCoordinator?.router.getNavigationController().tabBarItem.badgeValue = cartInfo.cart.getBadgeCount()
            })
            .disposed(by: disposeBag)
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

        UIApplication.shared.setRootView(pagesFactory.makeSBTabbarController())
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
        guard DefaultStorageImpl.sharedStorage.notFirstLaunch else { return }
        popToTabBar { [weak self] in
            switch pushNotification.pushType {
            case .info:
                break
            case .promotions:
                self?.openPromotion(pushNotification: pushNotification)
            case .orderRate:
                self?.openRateOrder(pushNotification: pushNotification)
            case .orderStatusUpdate:
                self?.openOrderHistory()
            }
        }
    }

    private func popToTabBar(completion: @escaping () -> Void) {
        var topViewController = UIApplication.topViewController()

        guard topViewController?.navigationController?.viewControllers.count == 1 else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            topViewController?.navigationController?.popViewController(animated: true)
            CATransaction.commit()
            return
        }

        guard topViewController?.presentingViewController == nil else {
            while topViewController?.presentingViewController != nil {
                topViewController = topViewController?.presentingViewController
                let last = topViewController?.presentingViewController == nil
                topViewController?.dismiss(
                    animated: last,
                    completion: last ? completion : nil
                )
            }
            return
        }

        completion()
    }

    private func openPromotion(pushNotification: PushNotification) {
        guard let promotionId = Int(pushNotification.pushTypeValue),
              let tabIndex = tabBarBarTypes.firstIndex(of: .menu) else { return }

        pagesFactory.makeSBTabbarController().selectedIndex = tabIndex
        let menuRepository = repositoryComponents.makeMenuRepository()
        menuRepository.openPromotion(by: promotionId)
    }

    private func openRateOrder(pushNotification: PushNotification) {
        openOrderHistory()

        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)
        let orderHistoryCoordinator = profileCoordinator.childCoordinators.first(where: { $0 is OrderHistoryCoordinator }) as! OrderHistoryCoordinator

        guard let orderId = Int(pushNotification.pushTypeValue) else { return }

        orderHistoryCoordinator.showRateOrderPage(of: orderId)
    }

    private func openOrderHistory() {
        guard let tabIndex = tabBarBarTypes.firstIndex(of: .profile) else { return }
        pagesFactory.makeSBTabbarController().selectedIndex = tabIndex

        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.showOrderHistoryPage()
    }
}
