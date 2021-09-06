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
    var toMenu: (() -> Void)?

    private let router: Router
    private let pagesFactory: OrderHistoryPagesFactory
    private let disposeBag = DisposeBag()

    init(router: Router, pagesFactory: OrderHistoryPagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let orderHistoryPage = pagesFactory.makeOrderHistoryPage()

        orderHistoryPage.onRateTapped = { [weak self] orderNumber in
            self?.showRateOrderPage(of: orderNumber)
        }

        orderHistoryPage.onShareTapped = { [weak self] in
            self?.showShareOrderPage()
        }

        orderHistoryPage.onTerminate = { [weak self] in
            self?.didFinish?()
        }

        orderHistoryPage.toMenu = { [weak self] in
            self?.toMenu?()
        }

        orderHistoryPage.finishFlow = { [weak self] in
            self?.router.popToRootViewController(animated: true)
        }

        orderHistoryPage.hidesBottomBarWhenPushed = true
        router.push(viewController: orderHistoryPage, animated: true)
    }

    func showRateOrderPage(of orderNumber: Int = 0) {
        let rateOrderPage = pagesFactory.makeRateOrderPage()

        rateOrderPage.setOrderNumber(with: orderNumber)

        rateOrderPage.outputs.close
            .subscribe(onNext: { [weak rateOrderPage] in
                rateOrderPage?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        rateOrderPage.outputs.finishFlow
            .subscribe(onNext: { [weak self, weak rateOrderPage] in
                rateOrderPage?.dismiss(animated: true) {
                    self?.router.popToRootViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)

        rateOrderPage.modalPresentationStyle = .pageSheet

        let nav = SBNavigationController(rootViewController: rateOrderPage)
        router.present(nav, animated: true, completion: nil)
    }

    private func showShareOrderPage() {
        let shareOrderPage = pagesFactory.makeShareOrderPage()
        router.push(viewController: shareOrderPage, animated: true)
    }
}
