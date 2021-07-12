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

        paymentSelectionVC.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                self?.handlePaymentTermination()
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.close
            .subscribe(onNext: { [weak self] in
                self?.router.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.onChangePaymentMethod
            .subscribe(onNext: { [weak self] in
                self?.showChangePaymentVC(on: paymentSelectionVC)
            }).disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentSelectionVC)
        router.present(navigationVC, animated: true, completion: nil)
    }

    private func showChangePaymentVC(on viewController: UIViewController) {
        let paymentMethodVC = pagesFactory.makePaymentMethodPage()

        paymentMethodVC.outputs.close
            .subscribe(onNext: {
                paymentMethodVC.dismiss(animated: true)
            }).disposed(by: disposeBag)

        paymentMethodVC.outputs.didSelectNewCard
            .subscribe(onNext: { [weak self] in
                self?.showCardPage(on: paymentMethodVC)
            }).disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentMethodVC)
        viewController.present(navigationVC, animated: true)
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
        didFinish?()
    }
}
