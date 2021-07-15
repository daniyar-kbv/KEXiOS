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
    func createOrder(dto: CreateOrderDTO) -> Single<Void>
    func createPayment(dto: CreatePaymentDTO) -> Single<OrderStatus>
}

final class PaymentsServiceMoyaImpl: PaymentsService {
    private let provider: MoyaProvider<PaymentsAPI>

    init(provider: MoyaProvider<PaymentsAPI>) {
        self.provider = provider
    }

    func createOrder(dto: CreateOrderDTO) -> Single<Void> {
        return provider.rx
            .request(.createOrder(dto: dto))
            .map { response in
                guard let response = try? response.map(CreateOrderResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
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
}
