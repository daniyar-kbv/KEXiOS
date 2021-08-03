//
//  PaymentMethodVCViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol PaymentMethodVCViewModel: AnyObject {
    var outputs: PaymentMethodVCViewModelImpl.Output { get }

    func getPaymentMethods()
    func getCountOfPaymentMethods() -> Int
    func getPaymentMethodInfo(for indexPath: IndexPath)
        -> (paymentMethodTitle: String, isSelected: Bool, isApplePay: Bool)
    func getPaymentMethod(for indexPath: IndexPath) -> PaymentMethod
    func selectPaymentMethod(at indexPath: IndexPath)
}

final class PaymentMethodVCViewModelImpl: PaymentMethodVCViewModel {
    private let disposeBag = DisposeBag()
    private let paymentRepository: PaymentRepository
    private var paymentMethods: [PaymentMethod] = []

    let outputs = Output()

    init(paymentRepository: PaymentRepository) {
        self.paymentRepository = paymentRepository

        bindRepository()
    }

    func getPaymentMethods() {
        paymentRepository.getPaymentMethods()
    }

    func getCountOfPaymentMethods() -> Int {
        return paymentMethods.count
    }

    func getPaymentMethodInfo(for indexPath: IndexPath) -> (paymentMethodTitle: String,
                                                            isSelected: Bool,
                                                            isApplePay: Bool)
    {
        let paymentMethod = paymentMethods[indexPath.row]
        return (paymentMethod.title,
                paymentMethod == paymentRepository.getSelectedPaymentMethod(),
                paymentMethod.type == .applePay)
    }

    func getPaymentMethod(for indexPath: IndexPath) -> PaymentMethod {
        return paymentMethods[indexPath.row]
    }

    func selectPaymentMethod(at indexPath: IndexPath) {
        let paymentMethod = paymentMethods[indexPath.row]
        switch paymentMethod.type {
        case .card, .cash:
            outputs.showPaymentMethod.accept(paymentMethod)
        case .savedCard, .applePay:
            paymentRepository.setSelected(paymentMethod: paymentMethod)
            outputs.didSelectPaymentMethod.accept(())
        }
    }

    private func bindRepository() {
        paymentRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        paymentRepository.outputs.paymentMethods
            .subscribe(onNext: { [weak self] paymentMethods in
                self?.paymentMethods = paymentMethods
                self?.outputs.needsUpdate.accept(())
                self?.outputs.canEdit.accept(paymentMethods.contains(where: { $0.type == .savedCard }))
            }).disposed(by: disposeBag)
    }
}

extension PaymentMethodVCViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let needsUpdate = PublishRelay<Void>()
        let didSelectPaymentMethod = PublishRelay<Void>()
        let showPaymentMethod = PublishRelay<PaymentMethod>()
        let canEdit = BehaviorRelay<Bool>(value: false)
    }
}
