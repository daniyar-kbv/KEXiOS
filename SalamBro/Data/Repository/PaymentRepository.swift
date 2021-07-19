//
//  PaymentRepository.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PaymentRepository: AnyObject {
    var outputs: PaymentRepositoryImpl.Output { get }

    func getSelectedPaymentMethod() -> PaymentMethod?
    func setSelected(paymentMethod: PaymentMethod)
    func getPaymentMethods()
    func makePayment()
}

final class PaymentRepositoryImpl: PaymentRepository {
    private let disposeBag = DisposeBag()
    private let paymentService: PaymentsService
    private let defaultStorage: DefaultStorage

    private var selectedPaymentMethod: PaymentMethod?
    private var paymentMethods: [PaymentMethod] = []

    let outputs = Output()

    init(paymentService: PaymentsService,
         defaultStorage: DefaultStorage)
    {
        self.paymentService = paymentService
        self.defaultStorage = defaultStorage
    }

    func setSelected(paymentMethod: PaymentMethod) {
        selectedPaymentMethod = paymentMethod
        outputs.selectedPaymentMethod.accept(paymentMethod)
    }

    func getPaymentMethods() {
        if paymentMethods.isEmpty {
            fetchSavedCards()
        }

        outputs.paymentMethods.accept(paymentMethods)
    }

    func getSelectedPaymentMethod() -> PaymentMethod? {
        return selectedPaymentMethod
    }
}

extension PaymentRepositoryImpl {
    private func fetchSavedCards() {
        outputs.didStartRequest.accept(())
        paymentService.myCards()
            .subscribe(onSuccess: { [weak self] cards in
                self?.outputs.didEndRequest.accept(())
                self?.process(cards: cards)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(cards: [MyCard]) {
        paymentMethods = cards.map { .init(type: .savedCard, value: $0) }
        paymentMethods.append(contentsOf: getDefaultPaymentMethods())

        outputs.paymentMethods.accept(paymentMethods)
    }

    private func getDefaultPaymentMethods() -> [PaymentMethod] {
        return [
            .init(type: .card),
            .init(type: .cash),
        ]
    }
}

extension PaymentRepositoryImpl {
    func makePayment() {
        switch selectedPaymentMethod?.type {
        case .savedCard:
            break
        case .card:
            createOrder(
                createPayment
            )
        case .cash:
            break
        default:
            break
        }
    }

    private func createOrder(_ completionHandler: (() -> Void)? = nil) {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        let createOrderDTO = CreateOrderDTO(leadUUID: leadUUID)

        outputs.didStartPaymentRequest.accept(())
        paymentService.createOrder(dto: createOrderDTO)
            .subscribe(onSuccess: { [weak self] in
                guard let completionHandler = completionHandler else {
                    self?.outputs.didEndPaymentRequest.accept(())
                    return
                }
                completionHandler()
            }, onError: { [weak self] error in
                self?.outputs.didEndPaymentRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func createPayment() {
        guard let leadUUID = defaultStorage.leadUUID,
              let card: PaymentCard = selectedPaymentMethod?.getValue(),
              let paymentType = selectedPaymentMethod?.type.apiType else { return }

        let createPaymentDTO = CreatePaymentDTO(leadUUID: leadUUID,
                                                paymentType: paymentType,
                                                cryptogram: card.cryptogram,
                                                cardholderName: card.cardholderName)

        paymentService.createPayment(dto: createPaymentDTO)
            .subscribe(onSuccess: { [weak self] orderStatus in
                self?.outputs.didEndPaymentRequest.accept(())
                self?.outputs.didMakePayment.accept(orderStatus)
            }, onError: { [weak self] error in
                self?.outputs.didEndPaymentRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

extension PaymentRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let didStartPaymentRequest = PublishRelay<Void>()
        let didEndPaymentRequest = PublishRelay<Void>()

        let selectedPaymentMethod = BehaviorRelay<PaymentMethod?>(value: nil)
        let paymentMethods = PublishRelay<[PaymentMethod]>()

        let didMakePayment = PublishRelay<OrderStatus>()
    }
}
