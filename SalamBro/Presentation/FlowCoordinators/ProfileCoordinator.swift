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

    init(router: Router, pagesFactory: ProfilePagesFactory, coordinatorsFactory: ProfileChildCoordinatorsFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
        self.coordinatorsFactory = coordinatorsFactory
        router.set(navigationController: router.getNavigationController())
    }

    override func start() {
        let profilePage = pagesFactory.makeProfilePage()

        profilePage.outputs.onChangeUserInfo
            .subscribe(onNext: { [weak self] userInfo in
                self?.showChangeUserInfoPage(userInfo: userInfo, completion: { newUserInfo in
                    profilePage.updateViews(with: newUserInfo)
                })
            })
            .disposed(by: disposeBag)

        profilePage.outputs.onTableItemPressed
            .subscribe(onNext: { [weak self] tableItem in
                switch tableItem {
                case .changeLanguage: self?.showChangeLanguagePage()
                case .deliveryAddress: self?.showDeliveryAddressPage()
                case .orderHistory: self?.showOrderHistoryPage()
                }
            })
            .disposed(by: disposeBag)

        router.push(viewController: profilePage, animated: true)
    }

    private func showChangeUserInfoPage(userInfo: UserInfoResponse, completion: ((UserInfoResponse) -> Void)?) {
        let changeUserInfoPage = pagesFactory.makeChangeUserInfoPage(userInfo: userInfo)
        changeUserInfoPage.hidesBottomBarWhenPushed = true

        changeUserInfoPage.outputs.didGetUserInfo
            .subscribe(onNext: { newUserInfo in
                completion?(newUserInfo)
            })
            .disposed(by: disposeBag)

        router.push(viewController: changeUserInfoPage, animated: true)
    }

    private func showChangeLanguagePage() {
        let changeLanguagePage = pagesFactory.makeChangeLanguagePage()
        changeLanguagePage.hidesBottomBarWhenPushed = true
        router.push(viewController: changeLanguagePage, animated: true)
    }

    private func showDeliveryAddressPage() {
        let addressListCoordinator = coordinatorsFactory.makeAddressListCoordinator()
        add(addressListCoordinator)

        addressListCoordinator.didFinish = { [weak self] in
            self?.remove(addressListCoordinator)
        }

        addressListCoordinator.start()
    }

    private func showOrderHistoryPage() {
        let orderHistoryCoordinator = coordinatorsFactory.makeOrderCoordinator()
        add(orderHistoryCoordinator)
        orderHistoryCoordinator.didFinish = { [weak self] in
            self?.remove(orderHistoryCoordinator)
        }

        orderHistoryCoordinator.start()
    }
}
