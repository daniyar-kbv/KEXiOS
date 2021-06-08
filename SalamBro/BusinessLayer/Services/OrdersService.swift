//
//  OrdersService.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 08.06.2021.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol OrdersService: AnyObject {
    func applyOrder(dto: OrderApplyDTO) -> Single<OrderApplyResponse>
    func decrement(dto: OrderIncDecrDTO) -> Single<OrderIncrDecrResponse>
    func increment(dto: OrderIncDecrDTO) -> Single<OrderIncrDecrResponse>
    func getProducts(for leadUUID: String) -> Single<OrderProductResponse>
    func updateCart(for leadUUID: String) -> Single<OrderUpdateCartResponse>
}

final class OrdersServiceMoyaImpl: OrdersService {
    private let provider: MoyaProvider<OrdersAPI>

    init(provider: MoyaProvider<OrdersAPI>) {
        self.provider = provider
    }

    func applyOrder(dto: OrderApplyDTO) -> Single<OrderApplyResponse> {
        return provider.rx
            .request(.apply(dto: dto))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let applyResponse = try? response.map(OrderApplyResponse.self) else {
                    throw NetworkError.badMapping
                }

                return applyResponse
            }
    }

    func decrement(dto: OrderIncDecrDTO) -> Single<OrderIncrDecrResponse> {
        return provider.rx
            .request(.decrement(dto: dto))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let incDecrResponse = try? response.map(OrderIncrDecrResponse.self) else {
                    throw NetworkError.badMapping
                }

                return incDecrResponse
            }
    }

    func increment(dto: OrderIncDecrDTO) -> Single<OrderIncrDecrResponse> {
        return provider.rx
            .request(.increment(dto: dto))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let incDecrResponse = try? response.map(OrderIncrDecrResponse.self) else {
                    throw NetworkError.badMapping
                }

                return incDecrResponse
            }
    }

    func getProducts(for leadUUID: String) -> Single<OrderProductResponse> {
        return provider.rx
            .request(.getProducts(leadUUID: leadUUID))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let orderProductsResponse = try? response.map(OrderProductResponse.self) else {
                    throw NetworkError.badMapping
                }

                return orderProductsResponse
            }
    }

    func updateCart(for leadUUID: String) -> Single<OrderUpdateCartResponse> {
        return provider.rx
            .request(.updateCart(leadUUID: leadUUID))
            .map { response in
                guard let orderUpdateCartResponse = try? response.map(OrderUpdateCartResponse.self) else {
                    throw NetworkError.badMapping
                }

                return orderUpdateCartResponse
            }
    }
}
