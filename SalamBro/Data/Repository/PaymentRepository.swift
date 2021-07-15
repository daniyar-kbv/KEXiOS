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
            paymentMethods.append(contentsOf: fetchSavedCards())
            paymentMethods.append(contentsOf: getDefaultPaymentMethods())
        }

        outputs.paymentMethods.accept(paymentMethods)
    }

    func getSelectedPaymentMethod() -> PaymentMethod? {
        return selectedPaymentMethod
    }

    func makePayment() {
        switch selectedPaymentMethod?.type {
        case .savedCard:
            break
        case .card:
            guard let leadUUID = defaultStorage.leadUUID,
                  let card: PaymentCard = selectedPaymentMethod?.getValue(),
                  let paymentType = selectedPaymentMethod?.type.apiType else { return }

            let createPaymentDTO = CreatePaymentDTO(leadUUID: leadUUID,
                                                    paymentType: paymentType,
                                                    cryptogram: card.cryptogram,
                                                    cardholderName: card.cardholderName)

            createOrder {
                self.paymentService.createPayment(dto: createPaymentDTO)
                    .subscribe(onSuccess: { [weak self] _ in
                        self?.outputs.didEndRequest.accept(())
                    }, onError: { [weak self] error in
                        self?.outputs.didEndRequest.accept(())
                        guard let error = error as? ErrorPresentable else { return }
                        self?.outputs.didGetError.accept(error)
                    })
                    .disposed(by: self.disposeBag)
            }
        case .cash:
            break
        default:
            break
        }
    }

    private func createOrder(_ completionHandler: (() -> Void)? = nil) {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        let createOrderDTO = CreateOrderDTO(leadUUID: leadUUID)

        outputs.didStartRequest.accept(())
        paymentService.createOrder(dto: createOrderDTO)
            .subscribe(onSuccess: { [weak self] in
                guard let completionHandler = completionHandler else {
                    self?.outputs.didEndRequest.accept(())
                    return
                }
                completionHandler()
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func fetchSavedCards() -> [PaymentMethod] {
        return [
            .init(type: .savedCard, value: SavedCard(id: 1, lastFourDigits: "1234")),
            .init(type: .savedCard, value: SavedCard(id: 2, lastFourDigits: "5678")),
        ]
    }

    private func getDefaultPaymentMethods() -> [PaymentMethod] {
        return [
            .init(type: .card),
            .init(type: .cash),
        ]
    }
}

extension PaymentRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let selectedPaymentMethod = BehaviorRelay<PaymentMethod?>(value: nil)
        let paymentMethods = PublishRelay<[PaymentMethod]>()

        let didMakePayment = PublishRelay<OrderStatus>()
    }
}
