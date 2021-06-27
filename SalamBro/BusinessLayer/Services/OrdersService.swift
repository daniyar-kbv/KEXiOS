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
    func applyOrder(dto: OrderApplyDTO) -> Single<String>
    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data>
    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<OrderProductDetailResponse.Data>
    func getCart(for leadUUID: String) -> Single<CartDTO>
    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<CartDTO>
}

final class OrdersServiceMoyaImpl: OrdersService {
    private let provider: MoyaProvider<OrdersAPI>

    init(provider: MoyaProvider<OrdersAPI>) {
        self.provider = provider
    }

    func applyOrder(dto: OrderApplyDTO) -> Single<String> {
        return provider.rx
            .request(.apply(dto: dto))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let applyResponse = try? response.map(OrderApplyResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = applyResponse.error {
                    throw error
                }

                guard let leadUUID = applyResponse.data?.uuid else {
                    throw NetworkError.error("Нет данных")
                }

                return leadUUID
            }
    }

    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data> {
        return provider.rx
            .request(.getProducts(leadUUID: leadUUID))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let orderProductsResponse = try? response.map(OrderProductResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let data = orderProductsResponse.data else {
                    throw NetworkError.error("Нет данных")
                }

                return data
            }
    }

    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<OrderProductDetailResponse.Data> {
        return provider.rx
            .request(.getProductDetail(leadUUID: leadUUID, productUUID: productUUID))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let orderProductDetailResponse = try? response.map(OrderProductDetailResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let data = orderProductDetailResponse.data else {
                    throw NetworkError.error("Нет данных")
                }

                return data
            }
    }

    func getCart(for leadUUID: String) -> Single<CartDTO> {
        return provider.rx
            .request(.getCart(leadUUID: leadUUID))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let cartResponse = try? response.map(CartDTO.self) else {
                    throw NetworkError.badMapping
                }

                return cartResponse
            }
    }

    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<CartDTO> {
        return provider.rx
            .request(.updateCart(leadUUID: leadUUID, dto: dto))
            .map { response in

                // MARK: Tech debt, в данный момент в swagger-е не прописаны ошибки для этого запроса, только success case

                guard let cartResponse = try? response.map(CartDTO.self) else {
                    throw NetworkError.badMapping
                }

                return cartResponse
            }
    }
}
