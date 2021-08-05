//
//  ProfileCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import RxCocoa
import RxSwift
import UIKit

final class ProfileCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    private(set) var router: Router
    private let pagesFactory: ProfilePagesFactory
    private let coordinatorsFactory: ProfileChildCoordinatorsFactory

    private var reloadProfilePage: (() -> Void)?

    var onLanguageChange: (() -> Void)?

    init(router: Router, pagesFactory: ProfilePagesFactory, coordinatorsFactory: ProfileChildCoordinatorsFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
        self.coordinatorsFactory = coordinatorsFactory
    }

    override func start() {
        let profilePage = makeProfilePage()

        router.set(navigationController: SBNavigationController(rootViewController: profilePage))
    }

    func restart() {
        let profilePage = makeProfilePage()

        router.getNavigationController().setViewControllers([profilePage], animated: false)
    }

    private func makeProfilePage() -> ProfilePage {
        let profilePage = pagesFactory.makeProfilePage()

        profilePage.outputs.onChangeUserInfo
            .subscribe(onNext: { [weak self, weak profilePage] userInfo in
                self?.showChangeUserInfoPage(userInfo: userInfo)
            })
            .disposed(by: disposeBag)

        reloadProfilePage = { [weak profilePage] in
            profilePage?.reloadPage()
        }

        profilePage.outputs.onTableItemPressed
            .subscribe(onNext: { [weak self] tableItem in
                switch tableItem {
                case .changeLanguage: self?.showChangeLanguagePage()
                case .deliveryAddress: self?.showDeliveryAddressPage()
                case .orderHistory: self?.showOrderHistoryPage()
                }
            })
            .disposed(by: disposeBag)

        profilePage.outputs.onLoginTapped
            .subscribe(onNext: { [weak self] in
                self?.startAuthCoordinator()
            })
            .disposed(by: disposeBag)

        return profilePage
    }

    private func showChangeUserInfoPage(userInfo: UserInfoResponse) {
        let changeUserInfoPage = pagesFactory.makeChangeUserInfoPage(userInfo: userInfo)
        changeUserInfoPage.hidesBottomBarWhenPushed = true

        changeUserInfoPage.outputs.didGetUserInfo
            .subscribe(onNext: { [weak self] in
                self?.router.pop(animated: true)
            })
            .disposed(by: disposeBag)

        router.push(viewController: changeUserInfoPage, animated: true)
    }

    private func showChangeLanguagePage() {
        let changeLanguagePage = pagesFactory.makeChangeLanguagePage()

        changeLanguagePage.outputs.restart
            .subscribe(onNext: { [weak self] in
                self?.router.pop(animated: true)
                self?.onLanguageChange?()
            })
            .disposed(by: disposeBag)

        changeLanguagePage.hidesBottomBarWhenPushed = true
        router.push(viewController: changeLanguagePage, animated: true)
    }

    private func showDeliveryAddressPage() {
        let addressListCoordinator = coordinatorsFactory.makeAddressListCoordinator()
        add(addressListCoordinator)

        addressListCoordinator.didFinish = { [weak self, weak addressListCoordinator] in
            self?.remove(addressListCoordinator)
            addressListCoordinator = nil
        }

        addressListCoordinator.start()
    }

    func showOrderHistoryPage() {
        let orderHistoryCoordinator = coordinatorsFactory.makeOrderCoordinator()
        add(orderHistoryCoordinator)
        orderHistoryCoordinator.didFinish = { [weak self, weak orderHistoryCoordinator] in
            self?.remove(orderHistoryCoordinator)
            orderHistoryCoordinator = nil
        }

        orderHistoryCoordinator.start()
    }

    private func startAuthCoordinator() {
        let authCoordinator = coordinatorsFactory.makeAuthCoordinator()
        add(authCoordinator)
        authCoordinator.didFinish = { [weak self, weak authCoordinator] in
            self?.remove(authCoordinator)
            authCoordinator = nil
            self?.reloadProfilePage?()
        }
        authCoordinator.start()
    }
}
