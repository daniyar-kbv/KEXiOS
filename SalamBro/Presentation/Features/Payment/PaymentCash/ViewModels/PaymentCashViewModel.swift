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

    func set(change: String?)
    func submit()
}

final class PaymentCashViewModelImpl: PaymentCashViewModel {
    private let disposeBag = DisposeBag()
    private let paymentRepository: PaymentRepository
    private var paymentMethod: PaymentMethod
    private var price: Double = 2770
    private var change: Int = 0

    lazy var outputs = Output(price: price)

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

    func set(change: String?) {
        guard let changeStr = change?.replacingOccurrences(of: " ", with: ""),
              let change = Int(changeStr)
        else {
            self.change = 0
            outputs.needChange.accept(false)
            outputs.isLessThanPrice.accept(false)
            return
        }
        self.change = change

        paymentMethod.set(value: change as Any)

        outputs.needChange.accept(true)
        outputs.isLessThanPrice.accept(Double(change) <= price)
    }

    func submit() {
        paymentRepository.setSelected(paymentMethod: paymentMethod)
    }
}

extension PaymentCashViewModelImpl {
    struct Output {
        let price: BehaviorRelay<String>
        let needChange = BehaviorRelay<Bool>(value: false)
        let isLessThanPrice = BehaviorRelay<Bool>(value: false)
        let onDone = PublishRelay<Void>()

        init(price: Double) {
            self.price = .init(value: price.formattedWithSeparator)
        }
    }
}
