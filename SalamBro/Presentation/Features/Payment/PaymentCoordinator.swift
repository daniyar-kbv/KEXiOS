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
                self?.showChangePaymentVC(on: paymentSelectionVC) { paymentMethod in
                    paymentSelectionVC.selected(paymentMethod: paymentMethod)
                }
            }).disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentSelectionVC)
        router.present(navigationVC, animated: true, completion: nil)
    }

    private func showChangePaymentVC(on viewController: UIViewController, _ onSelect: @escaping (PaymentMethodType) -> Void) {
        let paymentMethodVC = pagesFactory.makePaymentMethodPage()

        paymentMethodVC.outputs.close
            .subscribe(onNext: {
                paymentMethodVC.dismiss(animated: true)
            }).disposed(by: disposeBag)

        paymentMethodVC.outputs.didSelectPaymentMethod
            .subscribe(onNext: { [weak self] method in
                switch method {
                case .card:
                    self?.showCardPage(on: paymentMethodVC) {
                        paymentMethodVC.dismiss(animated: true)
                        onSelect(method)
                    }
                case .cash:
                    self?.showCashPage(on: paymentMethodVC) {
                        paymentMethodVC.dismiss(animated: true)
                        onSelect(method)
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentMethodVC)
        viewController.present(navigationVC, animated: true)
    }

    private func showCardPage(on viewController: UIViewController, _ onDone: @escaping () -> Void) {
        let cardPage = pagesFactory.makePaymentCardPage()

        cardPage.outputs.onDone
            .subscribe(onNext: {
                cardPage.dismiss(animated: false, completion: {
                    onDone()
                })
            }).disposed(by: disposeBag)

        cardPage.outputs.close
            .subscribe(onNext: {
                cardPage.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: cardPage)
        viewController.present(nav, animated: true)
    }

    private func showCashPage(on viewController: UIViewController, _ onDone: @escaping () -> Void) {
        let cashPage = pagesFactory.makePaymentCashPage()

        cashPage.outputs.onDone
            .subscribe(onNext: {
                cashPage.dismiss(animated: false, completion: {
                    onDone()
                })
            }).disposed(by: disposeBag)

        cashPage.outputs.close
            .subscribe(onNext: {
                cashPage.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: cashPage)
        viewController.present(nav, animated: true)
    }

    private func showPaymentInProcessView() {
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController as? UIViewController & AnimationViewPresentable else { return }

        viewController.showAnimationView(animationType: .payment) { [weak self] in
            self?.hideShowPaymentInProcessView()
        }
    }

    private func hideShowPaymentInProcessView() {
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController as? UIViewController & AnimationViewPresentable else { return }

        viewController.hideAnimationView()
    }
}

extension PaymentCoordinator {
    private func handlePaymentTermination() {
        didFinish?()
    }
}
