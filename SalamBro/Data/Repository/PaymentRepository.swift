//
//  PaymentRepository.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Cloudpayments
import Foundation
import RxCocoa
import RxSwift
import WebKit

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

    private var threeDsProcessor: ThreeDsProcessor?
    private var paymentUUID: String?

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
            createOrder(
                createCardPayment
            )
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
                self?.process(orderStatus: orderStatus)
            }, onError: { [weak self] error in
                self?.outputs.didEndPaymentRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func createCardPayment() {
        guard let leadUUID = defaultStorage.leadUUID,
              let card: MyCard = selectedPaymentMethod?.getValue() else { return }

        let dto = CardPaymentDTO(leadUUID: leadUUID, cardUUID: card.uuid)

        paymentService.createCardPayment(dto: dto)
            .subscribe(onSuccess: { [weak self] orderStatus in
                self?.outputs.didEndPaymentRequest.accept(())
                self?.process(orderStatus: orderStatus)
            }, onError: { [weak self] error in
                self?.outputs.didEndPaymentRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(orderStatus: OrderStatusProtocol) {
        switch orderStatus.determineStatus() {
        case .completed:
            outputs.didMakePayment.accept(())
        case .awaitingAuthentication:
            show3DS(orderStatus: orderStatus)
        default:
            guard let statusReason = orderStatus.statusReason else { return }
            let error = ErrorResponse(code: orderStatus.status, message: statusReason)
            outputs.didGetError.accept(error)
        }
    }

    private func show3DS(orderStatus: OrderStatusProtocol) {
        guard let paReq = orderStatus.paReq,
              let acsUrl = orderStatus.acsURL else { return }

        paymentUUID = orderStatus.uuid

        let data = ThreeDsData(transactionId: orderStatus.transactionId, paReq: paReq, acsUrl: acsUrl)
        threeDsProcessor = ThreeDsProcessor()
        threeDsProcessor?.make3DSPayment(with: data, delegate: self)
    }

    private func send3DS(paymentUUID: String, paRes: String, transactionId: String) {
        let dto = Create3DSPaymentDTO(paRes: paRes, transactionId: transactionId)

        outputs.didStartPaymentRequest.accept(())
        paymentService.confirm3DSPayment(dto: dto, paymentUUID: paymentUUID)
            .subscribe(onSuccess: { [weak self] orderStatus in
                self?.outputs.didEndPaymentRequest.accept(())
                self?.process(orderStatus: orderStatus)
            }, onError: { [weak self] error in
                self?.outputs.didEndPaymentRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

extension PaymentRepositoryImpl: ThreeDsDelegate {
    func willPresentWebView(_ webView: WKWebView) {
        outputs.show3DS.accept(webView)
    }

    func onAuthorizationCompleted(with md: String, paRes: String) {
        outputs.hide3DS.accept(())
        guard let paymentUUID = paymentUUID else { return }
        send3DS(paymentUUID: paymentUUID, paRes: paRes, transactionId: md)
        threeDsProcessor = nil
        self.paymentUUID = nil
    }

    func onAuthorizationFailed(with html: String) {
        threeDsProcessor = nil
        paymentUUID = nil
        outputs.hide3DS.accept(())
        print("error: \(html)")
    }
}

extension PaymentRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let didStartPaymentRequest = PublishRelay<Void>()
        let didEndPaymentRequest = PublishRelay<Void>()

        let show3DS = PublishRelay<WKWebView>()
        let hide3DS = PublishRelay<Void>()

        let selectedPaymentMethod = BehaviorRelay<PaymentMethod?>(value: nil)
        let paymentMethods = PublishRelay<[PaymentMethod]>()

        let didMakePayment = PublishRelay<Void>()
    }
}
