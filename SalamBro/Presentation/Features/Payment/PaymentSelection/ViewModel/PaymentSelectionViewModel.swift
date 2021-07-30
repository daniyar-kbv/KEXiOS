//
//  PaymentSelectionViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation
import RxCocoa
import RxSwift
import WebKit

protocol PaymentSelectionViewModel: AnyObject {
    var outputs: PaymentSelectionViewModelImpl.Output { get }

    func set(paymentMethod: PaymentMethod)
    func makePayment()
}

final class PaymentSelectionViewModelImpl: PaymentSelectionViewModel {
    private let disposeBag = DisposeBag()
    private let paymentRepository: PaymentRepository
    private let addressRepository: AddressRepository
    private let cartRepository: CartRepository
    private let defaultStorage: DefaultStorage

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
    }

    func set(paymentMethod: PaymentMethod) {
        outputs.didSelectPaymentMethod.accept(paymentMethod.title)
    }

    func makePayment() {
        paymentRepository.makePayment()
    }

    private func bindRepository() {
        paymentRepository.outputs.selectedPaymentMethod
            .subscribe(onNext: { [weak self] selectedPaymentMethod in
                guard let selectedPaymentMethod = selectedPaymentMethod else { return }
                self?.outputs.didSelectPaymentMethod.accept(selectedPaymentMethod.title)
            }).disposed(by: disposeBag)

        paymentRepository.outputs.didStartPaymentRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didEndPaymentRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didMakePayment
            .subscribe(onNext: { [weak self] in
                self?.finishPayment()
            }).disposed(by: disposeBag)

        paymentRepository.outputs.show3DS
            .bind(to: outputs.show3DS)
            .disposed(by: disposeBag)

        paymentRepository.outputs.hide3DS
            .bind(to: outputs.hide3DS)
            .disposed(by: disposeBag)
    }

    private func finishPayment() {
        defaultStorage.cleanUp(key: .leadUUID)
        cartRepository.cleanUp()
        addressRepository.applyOrder(userAddress: nil, completion: nil)
        outputs.didMakePayment.accept(())
    }
}

extension PaymentSelectionViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let didSelectPaymentMethod = PublishRelay<String>()
        let show3DS = PublishRelay<WKWebView>()
        let hide3DS = PublishRelay<Void>()
        let didMakePayment = PublishRelay<Void>()
    }
}
