//
//  PaymentCoordinator.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class PaymentCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    var didFinish: (() -> Void)?

    private(set) var router: Router
    private let pagesFactory: PaymentPagesFactory

    init(router: Router, pagesFactory: PaymentPagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let paymentSelectionVC = pagesFactory.makePaymentSelectionPage()
        let navigationVC = SBNavigationController(rootViewController: paymentSelectionVC)

        paymentSelectionVC.onChangePaymentMethod = { [weak self] in
            self?.showChangePaymentVC()
        }

        router.set(navigationController: navigationVC)
    }

    private func showChangePaymentVC() {
        let paymentMethodVC = pagesFactory.makePaymentMethodPage()

        paymentMethodVC.outputs.didSelectNewCard
            .subscribe(onNext: { [weak self] in
                self?.showCardPage(on: paymentMethodVC)
            }).disposed(by: disposeBag)

        router.push(viewController: paymentMethodVC, animated: true)
    }

    private func showCardPage(on viewController: UIViewController) {
        let cardPage = pagesFactory.makePaymentCardPage()

        cardPage.outputs.close
            .subscribe(onNext: {
                cardPage.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: cardPage)
        viewController.present(nav, animated: true)
    }
}

extension PaymentCoordinator {
    private func handlePaymentTermination() {
        router.dismiss(animated: true, completion: nil)
        didFinish?()
    }
}
