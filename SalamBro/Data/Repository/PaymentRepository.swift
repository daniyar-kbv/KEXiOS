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
    func setSelected(paymentMethod: PaymentMethod?)
    func fetchSavedCards()
    func getPaymentMethods()
    func makePayment()
    func makeApplePayPayment(payment: PKPayment)
    func deleteCards(with UUIDs: [String])
    func checkPaymentStatus()
}

final class PaymentRepositoryImpl: PaymentRepository {
    private let disposeBag = DisposeBag()
    private let paymentService: PaymentsService
    private let authorizedApplyService: AuthorizedApplyService
    private let defaultStorage: DefaultStorage
    private let cartStorage: CartStorage

    private var selectedPaymentMethod: PaymentMethod?
    private var localPaymentMethods: [PaymentMethod] = [.init(type: .card), .init(type: .applePay), .init(type: .cash)]
    private var paymentMethods: [PaymentMethod] = []

    private var threeDsProcessor: ThreeDsProcessor?
    private var paymentUUID: String?

    private var needSetDefaultPaymentMethod = true

    let outputs = Output()

    init(paymentService: PaymentsService,
         authorizedApplyService: AuthorizedApplyService,
         defaultStorage: DefaultStorage,
         cartStorage: CartStorage)
    {
        self.paymentService = paymentService
        self.authorizedApplyService = authorizedApplyService
        self.defaultStorage = defaultStorage
        self.cartStorage = cartStorage
    }

    func setSelected(paymentMethod: PaymentMethod?) {
        selectedPaymentMethod = paymentMethod
        outputs.selectedPaymentMethod.accept(paymentMethod)
    }

    func getPaymentMethods() {
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
}

//  MARK: - Saved Cards

extension PaymentRepositoryImpl {
    func fetchSavedCards() {
        outputs.didStartRequest.accept(())
        paymentService.myCards()
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] cards in
                self?.process(cards: cards)
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(cards: [MyCard]) {
        paymentMethods.removeAll()
        paymentMethods.append(contentsOf: cards.map { .init(type: .savedCard, value: $0) })
        paymentMethods.append(contentsOf: localPaymentMethods)

        getPaymentMethods()

        if let selectedPaymentMethod = selectedPaymentMethod,
           !paymentMethods.contains(selectedPaymentMethod)
        {
            setSelected(paymentMethod: nil)
        }

        if needSetDefaultPaymentMethod,
           let defaultPaymentMethod = paymentMethods.first(where: {
               guard let card: MyCard = $0.getValue() else { return false }
               return card.isCurrent
           })
        {
            needSetDefaultPaymentMethod = false
            setSelected(paymentMethod: defaultPaymentMethod)
        }
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
        Single.zip(sequences)
            .flatMap { [unowned self] _ in
                paymentService.myCards()
            }
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] cards in
                self?.process(cards: cards)
                self?.outputs.didEndRequest.accept(())
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
        defaultStorage.persist(isPaymentProcess: true)
        switch selectedPaymentMethod?.type {
        case .savedCard:
            makeSavedCardPayment()
        case .card:
            makeAppCardPayment()
        case .applePay:
            processApplePay()
        case .cash:
            createCashPayment()
        default:
            break
        }
    }

    func checkPaymentStatus() {
        guard defaultStorage.isPaymentProcess,
              let leadUUID = defaultStorage.leadUUID else { return }

        outputs.didStartPaymentRequest.accept(())
        paymentService.getPaymentStatus(leadUUID: leadUUID)
            .flatMap(orderStatusFlatMapClosure(_:))
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
    }

    private func makeSavedCardPayment() {
        guard let leadUUID = defaultStorage.leadUUID,
              let card: MyCard = selectedPaymentMethod?.getValue()
        else { return }

        let createOrderDTO = CreateOrderDTO(leadUUID: leadUUID)
        let createPaymentDTO = CardPaymentDTO(leadUUID: leadUUID, cardUUID: card.uuid)

        outputs.didStartPaymentRequest.accept(())
        paymentService.createOrder(dto: createOrderDTO)
            .flatMap { [unowned self] in paymentService.createCardPayment(dto: createPaymentDTO) }
            .flatMap(orderStatusFlatMapClosure(_:))
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
    }

    private func makeAppCardPayment() {
        guard let leadUUID = defaultStorage.leadUUID,
              let card: PaymentCard = selectedPaymentMethod?.getValue(),
              let paymentType = selectedPaymentMethod?.type.rawValue else { return }

        let createOrderDTO = CreateOrderDTO(leadUUID: leadUUID)
        let createPaymentDTO = CreatePaymentDTO(leadUUID: leadUUID,
                                                paymentType: paymentType,
                                                cryptogram: card.cryptogram,
                                                cardholderName: card.cardholderName,
                                                keepCard: card.keepCard,
                                                changeFor: nil)

        outputs.didStartPaymentRequest.accept(())
        paymentService.createOrder(dto: createOrderDTO)
            .flatMap { [unowned self] in paymentService.createPayment(dto: createPaymentDTO) }
            .flatMap(orderStatusFlatMapClosure(_:))
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
    }

    private func createCashPayment() {
        guard let leadUUID = defaultStorage.leadUUID,
              let paymentType = selectedPaymentMethod?.type.rawValue else { return }

        let createOrderDTO = CreateOrderDTO(leadUUID: leadUUID)
        let createPaymentDTO = CreatePaymentDTO(leadUUID: leadUUID,
                                                paymentType: paymentType,
                                                cryptogram: nil,
                                                cardholderName: nil,
                                                keepCard: nil,
                                                changeFor: selectedPaymentMethod?.getValue())

        outputs.didStartPaymentRequest.accept(())
        paymentService.createOrder(dto: createOrderDTO)
            .flatMap { [unowned self] in paymentService.createPayment(dto: createPaymentDTO) }
            .flatMap(orderStatusFlatMapClosure(_:))
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
    }

    private func orderStatusFlatMapClosure(_ orderStatus: PaymentStatus) -> Single<String> {
        switch orderStatus.determineStatus() {
        case .completed:
            return authorizedApplyService.authorizedApplyOrder()
        case .awaitingAuthentication:
            show3DS(orderStatus: orderStatus)
            outputs.didEndPaymentRequest.accept(())
            return .error(EmptyError())
        default:
            outputs.didEndPaymentRequest.accept(())
            guard let statusReason = orderStatus.statusReason else {
                return .error(NetworkError.badMapping)
            }
            let error = ErrorResponse(code: orderStatus.status, message: statusReason)
            return .error(error)
        }
    }

    private func paymentOnSuccess(_ leadUUID: String) {
        NotificationCenter.default.post(name: Constants.InternalNotification.leadUUID.name,
                                        object: leadUUID)
        NotificationCenter.default.post(name: Constants.InternalNotification.clearCart.name,
                                        object: ())
        defaultStorage.persist(isPaymentProcess: false)
        outputs.didEndPaymentRequest.accept(())
        outputs.didMakePayment.accept(())
    }

    private func paymentOnFailure(_ error: Error) {
        guard let error = error as? ErrorPresentable else { return }

        outputs.didEndPaymentRequest.accept(())
        defaultStorage.persist(isPaymentProcess: false)

        if let error = error as? ErrorResponse {
            switch error.code {
            case Constants.ErrorCode.orderAlreadyPaid:
                getNewLead()
            case Constants.ErrorCode.notFound:
                return
            default:
                break
            }
        }

        outputs.didGetError.accept(error)
    }

    private func getNewLead() {
        outputs.didStartRequest.accept(())
        authorizedApplyService.authorizedApplyOrder()
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] leadUUID in
                NotificationCenter.default.post(name: Constants.InternalNotification.leadUUID.name,
                                                object: leadUUID)
                NotificationCenter.default.post(name: Constants.InternalNotification.clearCart.name,
                                                object: ())
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else {
                    self?.outputs.didGetError.accept(NetworkError.badMapping)
                    return
                }
                self?.outputs.didGetError.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Apple pay

extension PaymentRepositoryImpl {
    func makeApplePayPayment(payment: PKPayment) {
        guard let cryptogram = payment.convertToString() else {
            print("Unable to create cryptogram")
            return
        }

        guard let leadUUID = defaultStorage.leadUUID,
              let paymentType = selectedPaymentMethod?.type.rawValue
        else { return }
        let createOrderDTO = CreateOrderDTO(leadUUID: leadUUID)
        let createPaymentDTO = CreatePaymentDTO(leadUUID: leadUUID,
                                                paymentType: paymentType,
                                                cryptogram: cryptogram,
                                                cardholderName: "",
                                                keepCard: nil,
                                                changeFor: nil)
        outputs.didStartPaymentRequest.accept(())
        paymentService.createOrder(dto: createOrderDTO)
            .flatMap { [unowned self] in paymentService.createPayment(dto: createPaymentDTO) }
            .flatMap(orderStatusFlatMapClosure(_:))
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
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
    private func show3DS(orderStatus: PaymentStatus) {
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
            .flatMap(orderStatusFlatMapClosure(_:))
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
    }

    func willPresentWebView(_ webView: WKWebView) {
        outputs.show3DS.accept(webView)
    }

    func onAuthorizationCompleted(with md: String, paRes: String) {
        outputs.hide3DS.accept(())
        threeDsProcessor = nil
        guard let paymentUUID = paymentUUID else { return }
        send3DS(paymentUUID: paymentUUID, paRes: paRes, transactionId: md)
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

        let selectedPaymentMethod = PublishRelay<PaymentMethod?>()
        let paymentMethods = PublishRelay<[PaymentMethod]>()
        let savedCards = PublishRelay<[MyCard]>()

        let didMakePayment = PublishRelay<Void>()
    }
}
