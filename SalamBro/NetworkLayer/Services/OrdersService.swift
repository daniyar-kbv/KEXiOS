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
    func authorizedApplyOrder() -> Single<String>
    func authorizedApplyWithAddress(dto: OrderApplyDTO) -> Single<String>
    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data>
    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<MenuPositionDetail>
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

    func authorizedApplyOrder() -> Single<String> {
        return provider.rx
            .request(.authorizedApply)
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

    func authorizedApplyWithAddress(dto: OrderApplyDTO) -> Single<String> {
        return provider.rx
            .request(.authorizedApplyWithAddress(dto: dto))
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
