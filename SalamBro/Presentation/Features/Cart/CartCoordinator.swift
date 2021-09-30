//
//  CartCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import RxCocoa
import RxSwift

final class CartCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private(set) var router: Router
    private let pagesFactory: CartPagesFactory
    private let coordinatorsFactory: CartCoordinatorsFactory

    var toMenu: (() -> Void)?
    var toOrderHistory: (() -> Void)?

    init(router: Router,
         pagesFactory: CartPagesFactory,
         coordinatorsFactory: CartCoordinatorsFactory)
    {
        self.router = router
        self.pagesFactory = pagesFactory
        self.coordinatorsFactory = coordinatorsFactory
    }

    override func start() {
        let cartPage = makeCartPage()

        router.set(navigationController: SBNavigationController(rootViewController: cartPage))
    }

    func restart() {
        let cartPage = makeCartPage()

        router.getNavigationController().setViewControllers([cartPage], animated: true)
    }

    private func makeCartPage() -> CartController {
        let cartPage = pagesFactory.makeCartPage()

        cartPage.outputs.toAuth
            .subscribe(onNext: { [weak self] in
                self?.startAuthCoordinator()
            })
            .disposed(by: disposeBag)

        cartPage.outputs.toPayment
            .subscribe(onNext: { [weak self] in
                self?.startPaymentCoordinator()
            })
            .disposed(by: disposeBag)

        cartPage.outputs.toMenu
            .subscribe(onNext: { [weak self] in
                self?.toMenu?()
            })
            .disposed(by: disposeBag)

        return cartPage
    }

    private func startAuthCoordinator() {
        let authCoordinator = coordinatorsFactory.makeAuthCoordinator()
        add(authCoordinator)

        authCoordinator.didFinish = { [weak self, weak authCoordinator] in
            self?.router.popToRootViewController(animated: true)
            self?.remove(authCoordinator)
        }

        authCoordinator.didAuthorize = { [weak self] in
            self?.startPaymentCoordinator()
        }

        authCoordinator.start()
    }

    private func startPaymentCoordinator() {
        let paymentCoordinator = coordinatorsFactory.makePaymentCoordinator()
        add(paymentCoordinator)

        paymentCoordinator.didFinish = { [weak self, weak paymentCoordinator] in
            self?.remove(paymentCoordinator)
            paymentCoordinator = nil
        }

        paymentCoordinator.didMakePayment = { [weak self] in
            self?.toOrderHistory?()
        }

        paymentCoordinator.didGetBranchClosed = { [weak self] in
            self?.toMenu?()
            NotificationCenter.default.post(name: Constants.InternalNotification.clearCart.name, object: nil)
        }

        paymentCoordinator.start()
    }

    func resumePayment() {
        startPaymentCoordinator()

        let paymentCoordinator = childCoordinators.first(where: { $0 is PaymentCoordinator }) as? PaymentCoordinator
        paymentCoordinator?.reloadPayment()
    }
}
