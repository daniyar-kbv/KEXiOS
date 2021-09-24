//
//  PaymentCoordinator.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

final class PaymentCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    var didFinish: (() -> Void)?
    var didMakePayment: (() -> Void)?

    private(set) var router: Router
    private let pagesFactory: PaymentPagesFactory

    private var threeDSController: ThreeDSViewController?
    private weak var paymentSelectionVC: PaymentSelectionViewController?

    init(router: Router, pagesFactory: PaymentPagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let paymentSelectionVC = pagesFactory.makePaymentSelectionPage()

        self.paymentSelectionVC = paymentSelectionVC

        paymentSelectionVC.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                self?.handlePaymentTermination()
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.close
            .subscribe(onNext: { [weak self] in
                self?.router.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.onChangePaymentMethod
            .subscribe(onNext: { [weak self, weak paymentSelectionVC] in
                self?.showChangePaymentVC(on: paymentSelectionVC)
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.show3DS
            .subscribe(onNext: { [weak self, weak paymentSelectionVC] webView in
                self?.show3DS(on: paymentSelectionVC, webView: webView)
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.hide3DS
            .subscribe(onNext: { [weak self] in
                self?.hide3DS()
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.didMakePayment
            .subscribe(onNext: { [weak self, weak paymentSelectionVC] in
                paymentSelectionVC?.dismiss(animated: true, completion: {
                    self?.didMakePayment?()
                })
            }).disposed(by: disposeBag)

        paymentSelectionVC.outputs.finishFlow
            .subscribe(onNext: { [weak self] in
                self?.router.dismissAll(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentSelectionVC)
        router.present(navigationVC, animated: true, completion: nil)
    }

    private func showChangePaymentVC(on viewController: UIViewController?) {
        let paymentMethodVC = pagesFactory.makePaymentMethodPage()

        paymentMethodVC.outputs.close
            .subscribe(onNext: { [weak paymentMethodVC] in
                paymentMethodVC?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        paymentMethodVC.outputs.didSelectPaymentMethod
            .subscribe(onNext: { [weak paymentMethodVC] in
                paymentMethodVC?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        paymentMethodVC.outputs.showPaymentMethod
            .subscribe(onNext: { [weak self, weak paymentMethodVC] paymentMethod in
                switch paymentMethod.type {
                case .card:
                    self?.showCardPage(on: paymentMethodVC,
                                       paymentMethod: paymentMethod) {
                        paymentMethodVC?.dismiss(animated: true)
                    }
                case .cash:
                    self?.showCashPage(on: paymentMethodVC,
                                       paymentMethod: paymentMethod) {
                        paymentMethodVC?.dismiss(animated: true)
                    }
                default:
                    break
                }
            }).disposed(by: disposeBag)

        paymentMethodVC.outputs.toEdit
            .subscribe(onNext: { [weak self, weak paymentMethodVC] in
                self?.showEditPage(on: paymentMethodVC)
            })
            .disposed(by: disposeBag)

        let navigationVC = SBNavigationController(rootViewController: paymentMethodVC)
        viewController?.present(navigationVC, animated: true)
    }

    private func showEditPage(on viewController: UIViewController?) {
        let editPage = pagesFactory.makePaymentEditPage()

        editPage.outputs.close
            .subscribe(onNext: { [weak editPage] in
                editPage?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: editPage)
        viewController?.present(nav, animated: true)
    }

    private func showCardPage(on viewController: UIViewController?,
                              paymentMethod: PaymentMethod,
                              _ onDone: @escaping () -> Void)
    {
        let cardPage = pagesFactory.makePaymentCardPage(paymentMethod: paymentMethod)

        cardPage.outputs.onDone
            .subscribe(onNext: { [weak cardPage] _ in
                cardPage?.dismiss(animated: false, completion: {
                    onDone()
                })
            }).disposed(by: disposeBag)

        cardPage.outputs.close
            .subscribe(onNext: { [weak cardPage] in
                cardPage?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: cardPage)
        viewController?.present(nav, animated: true)
    }

    private func showCashPage(on viewController: UIViewController?,
                              paymentMethod: PaymentMethod,
                              _ onDone: (() -> Void)?)
    {
        let cashPage = pagesFactory.makePaymentCashPage(paymentMethod: paymentMethod)

        cashPage.outputs.onDone
            .subscribe(onNext: { [weak cashPage] _ in
                cashPage?.dismiss(animated: false, completion: {
                    onDone?()
                })
            }).disposed(by: disposeBag)

        cashPage.outputs.close
            .subscribe(onNext: { [weak cashPage] in
                cashPage?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: cashPage)
        viewController?.present(nav, animated: true)
    }

    private func show3DS(on viewController: UIViewController?, webView: WKWebView) {
        threeDSController = pagesFactory.makeThreeDSPage(webView: webView)

        threeDSController?.outputs.close
            .subscribe(onNext: { [weak self] in
                self?.hide3DS()
            }).disposed(by: disposeBag)

        guard let threeDSController = threeDSController else { return }

        let nav = SBNavigationController(rootViewController: threeDSController)
        nav.modalPresentationStyle = .fullScreen

        viewController?.present(nav, animated: false)
    }

    private func hide3DS() {
        threeDSController?.dismiss(animated: false) { [weak self] in
            self?.threeDSController = nil
        }
    }

    func reloadPayment() {
        paymentSelectionVC?.reload()
    }
}

extension PaymentCoordinator {
    private func handlePaymentTermination() {
        didFinish?()
    }
}
