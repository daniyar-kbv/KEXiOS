//
//  PaymentSelectionViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation
import PassKit
import RxCocoa
import RxSwift
import WebKit

protocol PaymentSelectionViewModel: AnyObject {
    var outputs: PaymentSelectionViewModelImpl.Output { get }

    func reload()
    func getPaymentMethods()
    func set(paymentMethod: PaymentMethod)
    func makePayment()
    func processApplePay(payment: PKPayment)
}

final class PaymentSelectionViewModelImpl: PaymentSelectionViewModel {
    private let disposeBag = DisposeBag()
    private let paymentRepository: PaymentRepository
    private let addressRepository: AddressRepository
    private let cartRepository: CartRepository
    private let defaultStorage: DefaultStorage

    private var needsGetPaymentMethods = true

    let outputs = Output()

    init(paymentRepository: PaymentRepository,
         addressRepository: AddressRepository,
         cartRepository: CartRepository,
         defaultStorage: DefaultStorage)
    {
        self.paymentRepository = paymentRepository
        self.addressRepository = addressRepository
        self.cartRepository = cartRepository
        self.defaultStorage = defaultStorage

        bindRepository()
        setValues()
    }
}

extension PaymentSelectionViewModelImpl {
    func reload() {
        getPaymentMethods()
        paymentRepository.checkPaymentStatus()
    }

    func getPaymentMethods() {
        guard needsGetPaymentMethods else { return }
        needsGetPaymentMethods = false
        paymentRepository.fetchSavedCards()
    }

    func set(paymentMethod: PaymentMethod) {
        outputs.didSelectPaymentMethod.accept(paymentMethod)
    }

    func makePayment() {
        paymentRepository.makePayment()
    }

    func processApplePay(payment: PKPayment) {
        paymentRepository.makeApplePayPayment(payment: payment)
    }
}

extension PaymentSelectionViewModelImpl {
    private func setValues() {
        outputs.totalAmount.accept(.init(SBLocalization.localized(key: PaymentText.PaymentSelection.price,
                                                                  arguments: cartRepository.getTotalAmount().formattedWithSeparator)))
    }

    private func bindRepository() {
        paymentRepository.outputs.selectedPaymentMethod
            .subscribe(onNext: { [weak self] selectedPaymentMethod in
                self?.outputs.didSelectPaymentMethod.accept(selectedPaymentMethod)
            }).disposed(by: disposeBag)

        paymentRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didGetAuthError
            .bind(to: outputs.didGetAuthError)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didGetBranchError
            .bind(to: outputs.didGetBranchError)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didMakePayment
            .bind(to: outputs.didMakePayment)
            .disposed(by: disposeBag)

        paymentRepository.outputs.show3DS
            .bind(to: outputs.show3DS)
            .disposed(by: disposeBag)

        paymentRepository.outputs.hide3DS
            .bind(to: outputs.hide3DS)
            .disposed(by: disposeBag)

        paymentRepository.outputs.showApplePay
            .bind(to: outputs.showApplePay)
            .disposed(by: disposeBag)
    }
}

extension PaymentSelectionViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()

        let didGetError = PublishRelay<ErrorPresentable>()
        let didGetAuthError = PublishRelay<ErrorPresentable>()
        let didGetBranchError = PublishRelay<ErrorPresentable>()

        let totalAmount = BehaviorRelay<String?>(value: nil)
        let didSelectPaymentMethod = PublishRelay<PaymentMethod?>()
        let show3DS = PublishRelay<WKWebView>()
        let hide3DS = PublishRelay<Void>()
        let showApplePay = PublishRelay<PKPaymentAuthorizationViewController>()
        let didMakePayment = PublishRelay<Void>()
    }
}
