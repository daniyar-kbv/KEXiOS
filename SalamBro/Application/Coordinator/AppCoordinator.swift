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

        super.init()

        bindNotificationCenter()
        bindReachabilityManager()
        bindPaymentNotifications()
        bindUnavailableNotification()
    }

    override func start() {
        configureCoordinators()
        switchFlows()
        checkForInternet()
    }
}

//  MARK: - App start

extension AppCoordinator {
    private func bindNotificationCenter() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.startFirstFlow.name)
            .subscribe(onNext: { [weak self] _ in
                DefaultStorageImpl.sharedStorage.persist(notFirstLaunch: false)
                self?.restartApp()
                self?.switchFlows()
            })
            .disposed(by: disposeBag)
    }

    private func switchFlows() {
        guard DefaultStorageImpl.sharedStorage.notFirstLaunch else {
            AuthTokenStorageImpl.sharedStorage.cleanUp()
            startOnboardingFlow()
            return
        }

        showTabBarController()
        resumePaymentIfNeeded()
    }

    private func resumePaymentIfNeeded() {
        if DefaultStorageImpl.sharedStorage.isPaymentProcess,
           let cartTabIndex = tabBarBarTypes.firstIndex(of: .cart)
        {
            pagesFactory.makeSBTabbarController().selectedIndex = cartTabIndex

            let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

            cartCoordinator.startPaymentCoordinator()
        }
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

//  MARK: - Child coordinators config

extension AppCoordinator {
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

        menuCoordinator.router.getNavigationController().tabBarItem = SBTabBarType.menu.tabBarItem
    }

    private func restartProfileCoordinator() {
        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.restart()

        profileCoordinator.router.getNavigationController().tabBarItem = SBTabBarType.profile.tabBarItem
    }

    private func restartSupportCoordinator() {
        let supportCoordinator = appCoordinatorsFactory.makeSupportCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        supportCoordinator.restart()

        supportCoordinator.router.getNavigationController().tabBarItem = SBTabBarType.support.tabBarItem
    }

    private func restartCartCoordinator() {
        let cartCoordinator = appCoordinatorsFactory.makeCartCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        cartCoordinator.restart()

        cartCoordinator.router.getNavigationController().tabBarItem = SBTabBarType.cart.tabBarItem

        configCartTabBarItem(cartCoordinator: cartCoordinator)
    }
}

// MARK: - Push Notifications handling

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
        let orderHistoryCoordinator = profileCoordinator.childCoordinators.last(where: { $0 is OrderHistoryCoordinator }) as? OrderHistoryCoordinator

        guard let orderId = Int(pushNotification.pushTypeValue) else { return }

        orderHistoryCoordinator?.showRateOrderPage(of: orderId)
    }

    private func openOrderHistory() {
        guard let tabIndex = tabBarBarTypes.firstIndex(of: .profile) else { return }
        pagesFactory.makeSBTabbarController().selectedIndex = tabIndex

        let profileCoordinator = appCoordinatorsFactory.makeProfileCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents)

        profileCoordinator.showOrderHistoryPage()
    }
}

//  MARK: - Animation Presentation

extension AppCoordinator {
    private func showAnimation(type: LottieAnimationModel, action: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.subviews
            .first(where: { $0 is AnimationContainerView })?
            .removeFromSuperview()

        let animationView = AnimationContainerView(animationType: type)
        animationView.action = action

        UIApplication.shared.keyWindow?.addSubview(animationView)

        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        animationView.animationPlay()
    }

    private func hideAnimation(ifAnimationType: LottieAnimationModel? = nil) {
        let animationView = UIApplication.shared.keyWindow?.subviews
            .first(where: { $0 is AnimationContainerView }) as? AnimationContainerView

        if let animationType = ifAnimationType,
           animationView?.animationType != animationType
        {
            return
        }

        animationView?.removeFromSuperview()

        if [.noInternet, .overload].contains(animationView?.animationType) {
            (UIApplication.topViewController() as? Reloadable)?.reload()
            sendUpdateNotifications()
        }
    }

    private func sendUpdateNotifications() {
        let notifications: [Constants.InternalNotification] = [.updateMenu, .updateProfile, .updateDocuments, .updateMenu]

        notifications.forEach {
            NotificationCenter.default.post(name: $0.name, object: nil)
        }
    }
}

//  MARK: - Payment Process View handling

extension AppCoordinator {
    private func bindPaymentNotifications() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.showPaymentProcess.name)
            .subscribe(onNext: { [weak self] _ in
                self?.showAnimation(type: .payment)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.hidePaymentProcess.name)
            .subscribe(onNext: { [weak self] _ in
                self?.hideAnimation()
            })
            .disposed(by: disposeBag)
    }
}

//  MARK: - Network Connection View handling

extension AppCoordinator {
    private func bindReachabilityManager() {
        ReachabilityManagerImpl.shared.outputs
            .connectionDidChange
            .subscribe(onNext: { [weak self] isReachable in
                self?.processReachability(isReachable)
            })
            .disposed(by: disposeBag)
    }

    private func checkForInternet() {
        processReachability(ReachabilityManagerImpl.shared.getReachability())
    }

    private func processReachability(_ isReachable: Bool) {
        if isReachable {
            hideAnimation()
        } else {
            showAnimation(type: .noInternet)
        }
    }
}

//  MARK: - App Unavailable handling

extension AppCoordinator {
    private func bindUnavailableNotification() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.appUnavailable.name)
            .subscribe(onNext: { [weak self] _ in
                self?.showAnimation(type: .overload) {
                    NotificationCenter.default.post(name: Constants.InternalNotification.checkAvailability.name, object: nil)
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.appAvailable.name)
            .subscribe(onNext: { [weak self] _ in
                self?.hideAnimation(ifAnimationType: .overload)
            })
            .disposed(by: disposeBag)
    }
}
