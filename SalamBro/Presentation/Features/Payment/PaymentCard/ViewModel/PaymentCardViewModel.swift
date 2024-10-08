//
//  PaymentCardViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Cloudpayments
import Foundation
import RxCocoa
import RxSwift

protocol PaymentCardViewModel: AnyObject {
    var outputs: PaymentCardViewModelImpl.Output { get }

    func processCardInfo(cardNumber: String?, expiryDate: String?, cvv: String?, cardholderName: String?, needsSave: Bool)
}

final class PaymentCardViewModelImpl: PaymentCardViewModel {
    private let disposeBag = DisposeBag()
    private let paymentRepository: PaymentRepository
    private var paymentMethod: PaymentMethod

    let outputs = Output()

    init(paymentRepository: PaymentRepository,
         paymentMethod: PaymentMethod)
    {
        self.paymentRepository = paymentRepository
        self.paymentMethod = paymentMethod

        bindRepository()
    }

    private func bindRepository() {
        paymentRepository.outputs.selectedPaymentMethod
            .subscribe(onNext: { [weak self] _ in
                self?.outputs.onDone.accept(())
            }).disposed(by: disposeBag)
    }

    func processCardInfo(cardNumber: String?,
                         expiryDate: String?,
                         cvv: String?,
                         cardholderName: String?,
                         needsSave: Bool)
    {
        guard let cardNumber = cardNumber,
              let expiryDate = expiryDate,
              let cvv = cvv,
              let cardholderName = cardholderName else { return }

        guard Card.isCardNumberValid(cardNumber) else {
            outputs.didGetError.accept(())
            return
        }

        guard Card.isExpDateValid(expiryDate) else {
            outputs.didGetError.accept(())
            return
        }

        guard let cardCryptogramPacket = Card.makeCardCryptogramPacket(
            with: cardNumber,
            expDate: expiryDate,
            cvv: cvv,
            merchantPublicID: Constants.cloudpaymentsMerchantId
        ) else {
            print("Unable to create card cryptogram")
            return
        }

        paymentMethod.set(value: PaymentCard(cryptogram: cardCryptogramPacket,
                                             cardholderName: cardholderName,
                                             keepCard: needsSave))
        paymentRepository.setSelected(paymentMethod: paymentMethod)
    }
}

extension PaymentCardViewModelImpl {
    struct Output {
        let didGetError = PublishRelay<Void>()
        let onDone = PublishRelay<Void>()
    }
}
