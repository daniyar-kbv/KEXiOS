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
    private let ordersService: OrdersService
    private let defaultStorage: DefaultStorage
    private let cartStorage: CartStorage
    private let addressStorage: GeoStorage
    private let reachabilityManager: ReachabilityManager

    private var selectedPaymentMethod: PaymentMethod?
    private var localPaymentMethods: [PaymentMethod] = [.init(type: .card), .init(type: .applePay), .init(type: .cash)]
    private var paymentMethods: [PaymentMethod] = []

    private var threeDsProcessor: ThreeDsProcessor?
    private var paymentUUID: String?

    private var needSetDefaultPaymentMethod = true

    let outputs = Output()

    init(paymentService: PaymentsService,
         authorizedApplyService: AuthorizedApplyService,
         ordersService: OrdersService,
         defaultStorage: DefaultStorage,
         cartStorage: CartStorage,
         addressStorage: GeoStorage,
         reachabilityManager: ReachabilityManager)
    {
        self.paymentService = paymentService
        self.authorizedApplyService = authorizedApplyService
        self.ordersService = ordersService
        self.defaultStorage = defaultStorage
        self.cartStorage = cartStorage
        self.addressStorage = addressStorage
        self.reachabilityManager = reachabilityManager
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

        sendShowPaymentProcessNotification()

        paymentService.getPaymentStatus(leadUUID: leadUUID)
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

        sendShowPaymentProcessNotification()
        paymentService.createOrder(dto: createOrderDTO)
            .flatMap { [unowned self] in
                paymentService.createCardPayment(dto: createPaymentDTO)
            }
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

        createPayment(createOrderDTO: createOrderDTO, createPaymentDTO: createPaymentDTO)
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

        createPayment(createOrderDTO: createOrderDTO, createPaymentDTO: createPaymentDTO)
    }

    private func createPayment(createOrderDTO: CreateOrderDTO, createPaymentDTO: CreatePaymentDTO) {
        sendShowPaymentProcessNotification()
        paymentService.createOrder(dto: createOrderDTO)
            .flatMap { [unowned self] in paymentService.createPayment(dto: createPaymentDTO) }
            .retryWhenUnautharized()
            .subscribe(onSuccess: paymentOnSuccess(_:),
                       onError: paymentOnFailure(_:))
            .disposed(by: disposeBag)
    }

    private func paymentOnSuccess(_ paymentStatus: PaymentStatus) {
        switch paymentStatus.determineStatus() {
        case .completed:
            getNewLeadAuthorized()
        case .awaitingAuthentication:
            sendHidePaymentProcessNotification { [weak self] in
                self?.show3DS(orderStatus: paymentStatus)
            }
        default:
            sendHidePaymentProcessNotification { [weak self] in
                guard let statusReason = paymentStatus.statusReason else {
                    self?.outputs.didGetError.accept(NetworkError.badMapping)
                    return
                }

                let error = ErrorResponse(code: paymentStatus.status, message: statusReason)
                self?.outputs.didGetError.accept(error)
            }
        }
    }

    private func paymentOnFailure(_ error: Error) {
        guard let error = error as? ErrorPresentable,
              reachabilityManager.getReachability() else { return }
        sendHidePaymentProcessNotification { [weak self] in
            self?.defaultStorage.persist(isPaymentProcess: false)

            if let error = error as? ErrorResponse {
                switch error.code {
                case Constants.ErrorCode.orderAlreadyPaid:
                    self?.getNewLeadAuthorized()
                case Constants.ErrorCode.notFound:
                    return
                case Constants.ErrorCode.branchIsClosed:
                    self?.outputs.didGetAuthError.accept(error)
                    return
                default:
                    break
                }
            }

            if (error as? NetworkError) == .unauthorized {
                self?.outputs.didGetAuthError.accept(error)
                return
            }

            self?.outputs.didGetError.accept(error)
        }
    }

    private func getNewLeadAuthorized() {
        authorizedApplyService.authorizedApply(dto: nil)
            .retryWhenUnautharized()
            .subscribe(onSuccess: orderApplyOnSuccess(_:),
                       onError: { [weak self] _ in
                           self?.getNewLead()
                       })
            .disposed(by: disposeBag)
    }

    private func getNewLead() {
        guard let applyOrderDTO = addressStorage.userAddresses.first(where: { $0.isCurrent })?.toDTO() else { return }
        ordersService.applyOrder(dto: applyOrderDTO)
            .subscribe(onSuccess: orderApplyOnSuccess(_:),
                       onError: { [weak self] error in
                           guard self?.reachabilityManager.getReachability() == true else { return }
                           self?.sendHidePaymentProcessNotification {
                               self?.defaultStorage.persist(isPaymentProcess: false)
                               NotificationCenter.default.post(
                                   name: Constants.InternalNotification.startFirstFlow.name,
                                   object: nil
                               )
                               guard let error = error as? ErrorPresentable else {
                                   self?.outputs.didGetError.accept(NetworkError.badMapping)
                                   return
                               }
                               self?.outputs.didGetError.accept(error)
                           }
                       })
            .disposed(by: disposeBag)
    }

    private func orderApplyOnSuccess(_ leadUUID: String) {
        sendHidePaymentProcessNotification { [weak self] in
            NotificationCenter.default.post(name: Constants.InternalNotification.clearCart.name,
                                            object: ())
            NotificationCenter.default.post(name: Constants.InternalNotification.leadUUID.name,
                                            object: leadUUID)
            self?.outputs.didMakePayment.accept(())
            self?.defaultStorage.persist(isPaymentProcess: false)
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

        createPayment(createOrderDTO: createOrderDTO, createPaymentDTO: createPaymentDTO)
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

        sendShowPaymentProcessNotification()
        paymentService.confirm3DSPayment(dto: dto, paymentUUID: paymentUUID)
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
    private func sendShowPaymentProcessNotification() {
        NotificationCenter.default.post(name: Constants.InternalNotification.showPaymentProcess.name, object: nil)
    }

    private func sendHidePaymentProcessNotification(completion: (() -> Void)? = nil) {
        guard reachabilityManager.getReachability() else { return }
        NotificationCenter.default.post(
            name: Constants.InternalNotification.hidePaymentProcess.name,
            object: completion
        )
    }
}

extension PaymentRepositoryImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
        let didGetAuthError = PublishRelay<ErrorPresentable>()

        let show3DS = PublishRelay<WKWebView>()
        let hide3DS = PublishRelay<Void>()
        let showApplePay = PublishRelay<PKPaymentAuthorizationViewController>()

        let selectedPaymentMethod = PublishRelay<PaymentMethod?>()
        let paymentMethods = PublishRelay<[PaymentMethod]>()
        let savedCards = PublishRelay<[MyCard]>()

        let didMakePayment = PublishRelay<Void>()
        let finishFlow = PublishRelay<Void>()
    }
}
