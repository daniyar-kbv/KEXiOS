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
        outputs.totalAmount.accept("\(cartRepository.getTotalAmount().formattedWithSeparator) ₸")
    }

    private func bindRepository() {
        paymentRepository.outputs.selectedPaymentMethod
            .subscribe(onNext: { [weak self] selectedPaymentMethod in
                guard let selectedPaymentMethod = selectedPaymentMethod else { return }
                self?.outputs.didSelectPaymentMethod.accept(selectedPaymentMethod)
            }).disposed(by: disposeBag)

        paymentRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didStartPaymentRequest
            .bind(to: outputs.didStartPaymentRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didEndPaymentRequest
            .bind(to: outputs.didEndPaymentRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
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

        paymentRepository.outputs.paymentMethods
            .subscribe(onNext: { [weak self] paymentMethods in
                self?.process(paymentMethods: paymentMethods)
            })
            .disposed(by: disposeBag)
    }

    private func process(paymentMethods: [PaymentMethod]) {
        guard let currentPaymentMethod = paymentMethods.first(where: { paymentMethod in
            guard let savedCard: MyCard = paymentMethod.getValue() else { return false }
            return savedCard.isCurrent
        }) else { return }
        paymentRepository.setSelected(paymentMethod: currentPaymentMethod)
    }
}

extension PaymentSelectionViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()

        let didStartPaymentRequest = PublishRelay<Void>()
        let didEndPaymentRequest = PublishRelay<Void>()

        let didGetError = PublishRelay<ErrorPresentable>()

        let totalAmount = BehaviorRelay<String?>(value: nil)
        let didSelectPaymentMethod = PublishRelay<PaymentMethod>()
        let show3DS = PublishRelay<WKWebView>()
        let hide3DS = PublishRelay<Void>()
        let showApplePay = PublishRelay<PKPaymentAuthorizationViewController>()
        let didMakePayment = PublishRelay<Void>()
    }
}
