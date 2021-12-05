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
    func getAdditionalProducts(for leadUUID: String) -> Single<[AdditionalPosition]>
    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<Cart>
    func applyPromocode(promocode: String) -> Single<Promocode>
    func getLeadInfo(for leadUUID: String) -> Single<LeadInfo>
}

final class OrdersServiceMoyaImpl: OrdersService {
    private let provider: MoyaProvider<OrdersAPI>

    init(provider: MoyaProvider<OrdersAPI>) {
        self.provider = provider
    }

    func applyOrder(dto: OrderApplyDTO) -> Single<String> {
        return provider.rx
            .request(.apply(dto: dto))
            .retryWhenDeliveryChanged()
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

    func getAdditionalProducts(for leadUUID: String) -> Single<[AdditionalPosition]> {
        return provider.rx
            .request(.additionalNomenclature(leadUUID: leadUUID))
            .retryWhenDeliveryChanged()
            .map { response in

                guard let orderProductsResponse = try? response.map(AdditionalNomenclatureResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = orderProductsResponse.error {
                    throw error
                }

                guard let data = orderProductsResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func updateCart(for leadUUID: String, dto: CartDTO) -> Single<Cart> {
        return provider.rx
            .request(.updateCart(leadUUID: leadUUID, dto: dto))
            .retryWhenDeliveryChanged()
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
            .retryWhenDeliveryChanged()
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

    func getLeadInfo(for leadUUID: String) -> Single<LeadInfo> {
        return provider.rx
            .request(.leadInfo(leadUUID: leadUUID))
            .retryWhenDeliveryChanged()
            .map { response in

                guard let orderProductsResponse = try? response.map(OrdersShowResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = orderProductsResponse.error {
                    throw error
                }

                guard let data = orderProductsResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }
}
