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

    private let pagesFactory: ProfilePagesFactory

    private var addressListCoordinator: AddressListCoordinator?
    private var orderCoordinator: OrderHistoryCoordinator?

    private(set) var router: Router

    init(router: Router, pagesFactory: ProfilePagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
        router.set(navigationController: router.getNavigationController())
    }

    override func start() {
        let profilePage = pagesFactory.makeProfilePage()

        profilePage.outputs.onChangeUserInfo
            .subscribe(onNext: { [weak self] in
                self?.showChangeUserInfoPage()
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

    private func showChangeUserInfoPage() {
        let changeUserInfoPage = pagesFactory.makeChangeUserInfoPage()
        changeUserInfoPage.hidesBottomBarWhenPushed = true
        router.push(viewController: changeUserInfoPage, animated: true)
    }

    private func showChangeLanguagePage() {
        let changeLanguagePage = pagesFactory.makeChangeLanguagePage()
        changeLanguagePage.hidesBottomBarWhenPushed = true
        router.push(viewController: changeLanguagePage, animated: true)
    }

    private func showDeliveryAddressPage() {
        addressListCoordinator = AddressListCoordinator(navigationController: router.getNavigationController(),
                                                        pagesFactory: AddressListPagesFactoryImpl())

        addressListCoordinator?.didFinish = { [weak self] in
            self?.addressListCoordinator = nil
        }

        addressListCoordinator?.start()
    }

    private func showOrderHistoryPage() {
        orderCoordinator = OrderHistoryCoordinator(navigationController: router.getNavigationController(),
                                                   pagesFactory: OrderHistoryPagesFactoryImpl())

        orderCoordinator?.didFinish = { [weak self] in
            self?.orderCoordinator = nil
        }

        orderCoordinator?.start()
    }
}
