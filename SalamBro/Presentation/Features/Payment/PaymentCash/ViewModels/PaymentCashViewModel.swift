//
//  PaymentCashViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PaymentCashViewModel: AnyObject {
    var outputs: PaymentCashViewModelImpl.Output { get }

    func set(change: String)
}

final class PaymentCashViewModelImpl: PaymentCashViewModel {
    private var price: Double = 2770
    private var change: Int = 0

    lazy var outputs = Output(price: price)

    func set(change: String) {
        guard let change = Int(change.replacingOccurrences(of: " ", with: "")) else {
            self.change = 0
            outputs.needChange.accept(false)
            outputs.isLessThanPrice.accept(false)
            return
        }
        self.change = change
        outputs.needChange.accept(true)
        outputs.isLessThanPrice.accept(Double(change) <= price)
    }
}

extension PaymentCashViewModelImpl {
    struct Output {
        let price: BehaviorRelay<String>
        let needChange = BehaviorRelay<Bool>(value: false)
        let isLessThanPrice = BehaviorRelay<Bool>(value: false)

        init(price: Double) {
            self.price = .init(value: price.formattedWithSeparator)
        }
    }
}
