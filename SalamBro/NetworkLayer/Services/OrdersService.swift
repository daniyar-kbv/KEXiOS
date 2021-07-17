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
    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<MenuPositionDetail>
    func getCart(for leadUUID: String) -> Single<Cart>
    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<Cart>
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

                guard let applyResponse = try? response.map(OrderApplyResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = applyResponse.error {
                    throw error
                }

                guard let leadUUID = applyResponse.data?.uuid else {
                    throw NetworkError.noData
                }

                return leadUUID
            }
    }

    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data> {
        return provider.rx
            .request(.getProducts(leadUUID: leadUUID))
            .map { response in

                guard let orderProductsResponse = try? response.map(OrderProductResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let data = orderProductsResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<MenuPositionDetail> {
        return provider.rx
            .request(.getProductDetail(leadUUID: leadUUID, productUUID: productUUID))
            .map { response in

                guard let orderProductDetailResponse = try? response.map(OrderProductDetailResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let data = orderProductDetailResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func getCart(for leadUUID: String) -> Single<Cart> {
        return provider.rx
            .request(.getCart(leadUUID: leadUUID))
            .map { response in

                guard let cartResponse = try? response.map(OrderUpdateCartResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let cart = cartResponse.data else {
                    throw NetworkError.noData
                }

                return cart
            }
    }

    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<Cart> {
        return provider.rx
            .request(.updateCart(leadUUID: leadUUID, dto: dto))
            .map { response in

                guard let cartResponse = try? response.map(OrderUpdateCartResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let cart = cartResponse.data else {
                    throw NetworkError.noData
                }

                return cart
            }
    }
}
