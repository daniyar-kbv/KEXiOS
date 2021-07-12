//
//  PaymentSelectionViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol PaymentSelectionViewModel: AnyObject {
    var outputs: PaymentSelectionViewModelImpl.Output { get }

    func set(paymentMethod: PaymentMethodType)
}

final class PaymentSelectionViewModelImpl: PaymentSelectionViewModel {
    let outputs = Output()

    func set(paymentMethod: PaymentMethodType) {
        outputs.didSelectPaymentMethod.accept(paymentMethod.title)
    }
}

extension PaymentSelectionViewModelImpl {
    struct Output {
        let didSelectPaymentMethod = PublishRelay<String>()
    }
}
