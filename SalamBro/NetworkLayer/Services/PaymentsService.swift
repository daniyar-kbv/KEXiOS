//
//  PaymentsService.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol PaymentsService: AnyObject {
    func myCards() -> Single<[MyCard]>
    func deleteCard(uuid: String) -> Single<Void>
    func createOrder(dto: CreateOrderDTO) -> Single<Void>
    func createPayment(dto: CreatePaymentDTO) -> Single<OrderStatus>
    func createCardPayment(dto: CardPaymentDTO) -> Single<CardPaymentOrderStatus>
    func confirm3DSPayment(dto: Create3DSPaymentDTO, paymentUUID: String) -> Single<OrderStatus>
    func getPaymentStatus(leadUUID: String) -> Single<OrderStatus>
}

final class PaymentsServiceMoyaImpl: PaymentsService {
    private let provider: MoyaProvider<PaymentsAPI>

    init(provider: MoyaProvider<PaymentsAPI>) {
        self.provider = provider
    }

    func myCards() -> Single<[MyCard]> {
        return provider.rx
            .request(.myCards)
            .map { response in
                guard let response = try? response.map(MyCardsResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let myCards = response.data?.results else {
                    throw NetworkError.error(SBLocalization.localized(key: ErrorText.Network.noData))
                }

                return myCards
            }
    }

    func deleteCard(uuid: String) -> Single<Void> {
        return provider.rx
            .request(.deleteCard(uuid: uuid))
            .map { response in
                if response.response?.statusCode == Constants.StatusCode.noContent {
                    return ()
                }

                guard let response = try? response.map(DeleteCardResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                return ()
            }
    }

    func createOrder(dto: CreateOrderDTO) -> Single<Void> {
        return provider.rx
            .request(.createOrder(dto: dto))
            .map { response in
                guard let response = try? response.map(CreateOrderResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    guard error.code != Constants.ErrorCode.orderAlreadyExists else {
                        return ()
                    }

                    throw error
                }

                guard response.data?.leadUUID != nil else {
                    throw NetworkError.error(SBLocalization.localized(key: ErrorText.Network.noData))
                }

                return ()
            }
    }

    func createPayment(dto: CreatePaymentDTO) -> Single<OrderStatus> {
        return provider.rx
            .request(.createPayment(dto: dto))
            .map { response in
                guard let response = try? response.map(CreatePaymentResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let status = response.data else {
                    throw NetworkError.error(SBLocalization.localized(key: ErrorText.Network.noData))
                }

                return status
            }
    }

    func createCardPayment(dto: CardPaymentDTO) -> Single<CardPaymentOrderStatus> {
        return provider.rx
            .request(.createCardPayment(dto: dto))
            .map { response in
                guard let response = try? response.map(CardPaymentResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let status = response.data else {
                    throw NetworkError.error(SBLocalization.localized(key: ErrorText.Network.noData))
                }

                return status
            }
    }

    func confirm3DSPayment(dto: Create3DSPaymentDTO, paymentUUID: String) -> Single<OrderStatus> {
        return provider.rx
            .request(.confirm3DSPayment(dto: dto, paymentUUID: paymentUUID))
            .map { response in
                guard let response = try? response.map(CreatePaymentResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let status = response.data else {
                    throw NetworkError.error(SBLocalization.localized(key: ErrorText.Network.noData))
                }

                return status
            }
    }

    func getPaymentStatus(leadUUID: String) -> Single<OrderStatus> {
        return provider.rx
            .request(.paymentStatus(leadUUID: leadUUID))
            .map { response in
                guard let response = try? response.map(CreatePaymentResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let status = response.data else {
                    throw NetworkError.error(SBLocalization.localized(key: ErrorText.Network.noData))
                }

                return status
            }
    }
}
