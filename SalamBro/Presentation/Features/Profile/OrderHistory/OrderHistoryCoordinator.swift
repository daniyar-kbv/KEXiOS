//
//  OrderHistoryCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import RxCocoa
import RxSwift
import UIKit

final class OrderHistoryCoordinator: BaseCoordinator {
    var didFinish: (() -> Void)?

    private let router: Router
    private let pagesFactory: OrderHistoryPagesFactory
    private let disposeBag = DisposeBag()

    init(router: Router, pagesFactory: OrderHistoryPagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let orderHistoryPage = pagesFactory.makeOrderHistoryPage()

        orderHistoryPage.onRateTapped = { [weak self] in
            self?.showRateOrderPage()
        }

        orderHistoryPage.onShareTapped = { [weak self] in
            self?.showShareOrderPage()
        }

        orderHistoryPage.onTerminate = { [weak self] in
            self?.didFinish?()
        }

        orderHistoryPage.hidesBottomBarWhenPushed = true
        router.push(viewController: orderHistoryPage, animated: true)
    }

    func showRateOrderPage() {
        let rateOrderPage = pagesFactory.makeRateOrderPage()

        rateOrderPage.outputs.close
            .subscribe(onNext: {
                rateOrderPage.dismiss(animated: true)
            }).disposed(by: disposeBag)

        rateOrderPage.modalPresentationStyle = .pageSheet
        let nav = SBNavigationController(rootViewController: rateOrderPage)
        router.present(nav, animated: true, completion: nil)
    }

    private func showShareOrderPage() {
        let shareOrderPage = pagesFactory.makeShareOrderPage()
        router.push(viewController: shareOrderPage, animated: true)
    }
}
