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
    func getOrders() -> Single<[OrdersList]>
    func applyOrder(dto: OrderApplyDTO) -> Single<String>
    func getAdditionalProducts(for leadUUID: String) -> Single<[MenuPosition]>
    func getCart(for leadUUID: String) -> Single<Cart>
    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<Cart>
    func applyPromocode(promocode: String) -> Single<Promocode>
}

final class OrdersServiceMoyaImpl: OrdersService {
    private let provider: MoyaProvider<OrdersAPI>

    init(provider: MoyaProvider<OrdersAPI>) {
        self.provider = provider
    }

    func getOrders() -> Single<[OrdersList]> {
        return provider.rx
            .request(.getAllOrders)
            .map { response in
                guard let ordersResponse = try? response.map(OrdersListResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = ordersResponse.error {
                    throw error
                }

                guard let ordersList = ordersResponse.data?.results else {
                    throw NetworkError.noData
                }

                return ordersList
            }
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

    func getAdditionalProducts(for leadUUID: String) -> Single<[MenuPosition]> {
        return provider.rx
            .request(.additionalNomenclature(leadUUID: leadUUID))
            .map { response in

                guard let orderProductsResponse = try? response.map(AdditionalNomenclatureResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let data = orderProductsResponse.data?.results else {
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

                if let error = cartResponse.error {
                    throw error
                }

                guard let cart = cartResponse.data else {
                    throw NetworkError.noData
                }

                return cart
            }
    }

    func applyPromocode(promocode: String) -> Single<Promocode> {
        return provider.rx
            .request(.applyPromocode(promocode: promocode))
            .map { response in
                guard let promocodeResponse = try? response.map(PromocodeResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = promocodeResponse.error {
                    throw error
                }

                guard let promocode = promocodeResponse.data else {
                    throw NetworkError.noData
                }

                return promocode
            }
    }
}
