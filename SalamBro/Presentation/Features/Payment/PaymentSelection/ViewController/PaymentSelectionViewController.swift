//
//  PaymentSelectionViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Cloudpayments
import PassKit
import RxCocoa
import RxSwift
import UIKit
import WebKit

final class PaymentSelectionViewController: UIViewController, LoaderDisplayable {
    private let disposeBag = DisposeBag()
    private let viewModel: PaymentSelectionViewModel
    private lazy var contentView: PaymentSelectionContainerView = {
        let view = PaymentSelectionContainerView()
        view.delegate = self
        return view
    }()

    let outputs = Output()

    init(viewModel: PaymentSelectionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        outputs.didTerminate.accept(())
    }

    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: PaymentText.PaymentSelection.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.getPaymentMethods()
    }

    private func bindViewModel() {
        viewModel.outputs.didSelectPaymentMethod
            .subscribe(onNext: { [weak self] paymentMethod in
                self?.contentView.setPaymentMethod(paymentMethod: paymentMethod)
            }).disposed(by: disposeBag)

        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didStartPaymentRequest
            .bind(to: outputs.didStartPaymentRequest)
            .disposed(by: disposeBag)

        viewModel.outputs.didEndPaymentRequest
            .bind(to: outputs.didEndPaymentRequest)
            .disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.show3DS
            .bind(to: outputs.show3DS)
            .disposed(by: disposeBag)

        viewModel.outputs.hide3DS
            .bind(to: outputs.hide3DS)
            .disposed(by: disposeBag)

        viewModel.outputs.showApplePay
            .subscribe(onNext: { [weak self] controller in
                self?.show(controller: controller)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didMakePayment
            .bind(to: outputs.didMakePayment)
            .disposed(by: disposeBag)

        viewModel.outputs.totalAmount
            .subscribe(onNext: { [weak self] totalAmount in
                self?.contentView.set(totalAmount: totalAmount)
            })
            .disposed(by: disposeBag)
    }
}

extension PaymentSelectionViewController: PaymentSelectionContainerViewDelegate {
    func handleChangePaymentMethod() {
        outputs.onChangePaymentMethod.accept(())
    }

    func handleSubmitButtonTap() {
        viewModel.makePayment()
    }
}

extension PaymentSelectionViewController: PKPaymentAuthorizationViewControllerDelegate {
    private func show(controller: PKPaymentAuthorizationViewController) {
        controller.delegate = self
        present(controller, animated: true)
    }

    func paymentAuthorizationViewController(_: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)

        viewModel.processApplePay(payment: payment)
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
}

extension PaymentSelectionViewController {
    struct Output {
        let didStartPaymentRequest = PublishRelay<Void>()
        let didEndPaymentRequest = PublishRelay<Void>()

        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()
        let onChangePaymentMethod = PublishRelay<Void>()
        let show3DS = PublishRelay<WKWebView>()
        let hide3DS = PublishRelay<Void>()
        let didMakePayment = PublishRelay<Void>()
    }
}
