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

        paymentSelectionVC.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showPaymentInProcessView(on: paymentSelectionVC)
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hidePaymentInProcessView(on: paymentSelectionVC)
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

        paymentMethodVC.outputs.didSelectPaymentMethod
            .subscribe(onNext: {
                paymentMethodVC.dismiss(animated: true)
            }).disposed(by: disposeBag)

        paymentMethodVC.outputs.showPaymentMethod
            .subscribe(onNext: { [weak self] paymentMethod in
                switch paymentMethod.type {
                case .card:
                    self?.showCardPage(on: paymentMethodVC,
                                       paymentMethod: paymentMethod) {
                        paymentMethodVC.dismiss(animated: true)
                    }
                case .cash:
                    self?.showCashPage(on: paymentMethodVC,
                                       paymentMethod: paymentMethod) {
                        paymentMethodVC.dismiss(animated: true)
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentMethodVC)
        viewController.present(navigationVC, animated: true)
    }

    private func showCardPage(on viewController: UIViewController,
                              paymentMethod: PaymentMethod,
                              _ onDone: @escaping () -> Void)
    {
        let cardPage = pagesFactory.makePaymentCardPage(paymentMethod: paymentMethod)

        cardPage.outputs.onDone
            .subscribe(onNext: { _ in
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

    private func showCashPage(on viewController: UIViewController,
                              paymentMethod: PaymentMethod,
                              _ onDone: @escaping () -> Void)
    {
        let cashPage = pagesFactory.makePaymentCashPage(paymentMethod: paymentMethod)

        cashPage.outputs.onDone
            .subscribe(onNext: { _ in
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

    private func showPaymentInProcessView(on viewController: UIViewController & AnimationViewPresentable) {
        viewController.showAnimationView(animationType: .payment, fullScreen: true) {
//            Tech debt
        }
    }

    private func hidePaymentInProcessView(on viewController: UIViewController & AnimationViewPresentable) {
        viewController.hideAnimationView()
    }
}

extension PaymentCoordinator {
    private func handlePaymentTermination() {
        didFinish?()
    }
}
