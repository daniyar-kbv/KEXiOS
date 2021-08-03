//
//  PaymentRepository.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Cloudpayments
import Foundation
import PassKit
import RxCocoa
import RxSwift
import WebKit

protocol PaymentRepository: AnyObject {
    var outputs: PaymentRepositoryImpl.Output { get }

    func getSelectedPaymentMethod() -> PaymentMethod?
    func setSelected(paymentMethod: PaymentMethod)
    func getPaymentMethods()
    func makePayment()
    func makeApplePayPayment(payment: PKPayment)
    func deleteCards(with UUIDs: [String])
}

final class PaymentRepositoryImpl: PaymentRepository {
    private let disposeBag = DisposeBag()
    private let paymentService: PaymentsService
    private let defaultStorage: DefaultStorage
    private let cartStorage: CartStorage

    private var selectedPaymentMethod: PaymentMethod?
    private var paymentMethods: [PaymentMethod] = []

    private var threeDsProcessor: ThreeDsProcessor?
    private var paymentUUID: String?

    let outputs = Output()

    init(paymentService: PaymentsService,
         defaultStorage: DefaultStorage,
         cartStorage: CartStorage)
    {
        self.paymentService = paymentService
        self.defaultStorage = defaultStorage
        self.cartStorage = cartStorage
    }

    func setSelected(paymentMethod: PaymentMethod) {
        selectedPaymentMethod = paymentMethod
        outputs.selectedPaymentMethod.accept(paymentMethod)
    }

    func getPaymentMethods() {
        guard !paymentMethods.isEmpty else {
            fetchSavedCards()
            return
        }

        outputs.paymentMethods.accept(paymentMethods)

        let savedCards = paymentMethods
            .map { card -> MyCard? in
                guard let myCard: MyCard = card.getValue()
                else { return nil }
                return myCard
            }
            .compactMap { $0 }
        outputs.savedCards.accept(savedCards)
    }

    func getSelectedPaymentMethod() -> PaymentMethod? {
        return selectedPaymentMethod
    }

    private func getDefaultPaymentMethods() -> [PaymentMethod] {
        return [
            .init(type: .card),
            .init(type: .applePay),
            .init(type: .cash),
        ]
    }
}

//  MARK: - Saved Cards

extension PaymentRepositoryImpl {
    private func fetchSavedCards() {
        outputs.didStartRequest.accept(())
        paymentService.myCards()
            .subscribe(onSuccess: { [weak self] cards in
                self?.outputs.didEndRequest.accept(())
                self?.process(cards: cards)
                self?.outputs.savedCards.accept(cards)
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

    func deleteCards(with UUIDs: [String]) {
        let sequences = paymentMethods
            .filter { paymentMethod in
                guard let card: MyCard = paymentMethod.getValue(),
                      UUIDs.contains(card.uuid)
                else { return false }
                return true
            }
            .map { paymentMethod -> Single<Void>? in
                guard let card: MyCard = paymentMethod.getValue() else { return nil }
                return paymentService.deleteCard(uuid: card.uuid)
            }
            .compactMap { $0 }

        outputs.didStartRequest.accept(())
        Single.zip(sequences,
                   resultSelector: { _ -> Void in })
            .subscribe(onSuccess: { [weak self] in
                self?.paymentMethods.removeAll()
                self?.getPaymentMethods()
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Payments

extension PaymentRepositoryImpl {
    func makePayment() {
        switch selectedPaymentMethod?.type {
        case .savedCard:
            createOrder(
                createCardPayment
            )
        case .card:
            createOrder(
                makeCardPayment
            )
        case .applePay:
            processApplePay()
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

    private func makeCardPayment() {
        guard let leadUUID = defaultStorage.leadUUID,
              let card: PaymentCard = selectedPaymentMethod?.getValue(),
              let paymentType = selectedPaymentMethod?.type.apiType else { return }

        createPayment(leadUUID: leadUUID,
                      paymentType: paymentType,
                      cryptogram: card.cryptogram,
                      cardholderName: card.cardholderName,
                      keepCard: card.keepCard)
    }

    private func createPayment(leadUUID: String,
                               paymentType: String,
                               cryptogram: String,
                               cardholderName: String,
                               keepCard: Bool?)
    {
        let createPaymentDTO = CreatePaymentDTO(leadUUID: leadUUID,
                                                paymentType: paymentType,
                                                cryptogram: cryptogram,
                                                cardholderName: cardholderName,
                                                keepCard: keepCard)

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
}

// MARK: - Apple pay

extension PaymentRepositoryImpl {
    func makeApplePayPayment(payment: PKPayment) {
        guard let cryptogram = payment.convertToString() else {
            print("Unable to create cryptogram")
            return
        }
//        Tech debt: remove
        UIPasteboard.general.string = cryptogram
        selectedPaymentMethod?.set(value: cryptogram)
        createOrder { [weak self] in
            guard let leadUUID = self?.defaultStorage.leadUUID,
                  let paymentType = self?.selectedPaymentMethod?.type.apiType else { return }
            self?.createPayment(leadUUID: leadUUID,
                                paymentType: paymentType,
                                cryptogram: cryptogram,
                                cardholderName: "",
                                keepCard: nil)
        }
    }

    private func processApplePay() {
        let request = PKPaymentRequest()
        request.merchantIdentifier = Constants.applePayMerchantId
        request.supportedNetworks = [.visa, .masterCard]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "RU"
        request.currencyCode = "KZT"
        request.paymentSummaryItems = cartStorage.cart.items.map { .init(label: $0.position.name, amount: NSDecimalNumber(value: $0.getNumericPrice())) }
        guard let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        else { return }
        outputs.showApplePay.accept(applePayController)
    }
}

//  MARK: - 3DS

extension PaymentRepositoryImpl: ThreeDsDelegate {
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
        let showApplePay = PublishRelay<PKPaymentAuthorizationViewController>()

        let selectedPaymentMethod = BehaviorRelay<PaymentMethod?>(value: nil)
        let paymentMethods = PublishRelay<[PaymentMethod]>()
        let savedCards = PublishRelay<[MyCard]>()

        let didMakePayment = PublishRelay<Void>()
    }
}
