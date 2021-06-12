//
//  OrderHistoryCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import UIKit

final class OrderHistoryCoordinator {
    var didFinish: (() -> Void)?

    private let navigationController: UINavigationController
    private let pagesFactory: OrderHistoryPagesFactory

    init(navigationController: UINavigationController, pagesFactory: OrderHistoryPagesFactory) {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory
    }

    func start() {
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
        navigationController.pushViewController(orderHistoryPage, animated: true)
    }

    private func showRateOrderPage() {
        let rateOrderPage = pagesFactory.makeRateOrderPage()
        navigationController.present(rateOrderPage, animated: true, completion: nil)
    }

    private func showShareOrderPage() {
        let shareOrderPage = pagesFactory.makeShareOrderPage()
        navigationController.pushViewController(shareOrderPage, animated: true)
    }
}
