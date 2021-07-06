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

    private let router: Router
    private let pagesFactory: PaymentPagesFactory

    init(router: Router, pagesFactory: PaymentPagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let paymentSelectionVC = pagesFactory.makePaymentSelectionPage()
        let navVC = SBNavigationController(rootViewController: paymentSelectionVC)
        router.present(navVC, animated: true, completion: nil)
    }
}

extension PaymentCoordinator {
    private func handlePaymentTermination() {
        router.dismiss(animated: true, completion: nil)
        didFinish?()
    }
}
