//
//  PromotionsService.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol MenuService: AnyObject {
    func getProducts() -> Single<[MenuCategory]>
    func getProductDetail(by productUUID: String) -> Single<MenuPositionDetail>
    func getPromotions() -> Single<PromotionResult>
    func getPromotionDetail(by id: Int) -> Single<Promotion>
}

class MenuServiceImpl: MenuService {
    private let provider: MoyaProvider<MenuAPI>

    init(provider: MoyaProvider<MenuAPI>) {
        self.provider = provider
    }

    func getProducts() -> Single<[MenuCategory]> {
        return provider.rx
            .request(.products)
            .retryWhenDeliveryChanged()
            .map { response in
                guard let orderProductsResponse = try? response.map(OrderProductResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = orderProductsResponse.error {
                    throw error
                }

                guard let data = orderProductsResponse.data?.categories else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func getProductDetail(by productUUID: String) -> Single<MenuPositionDetail> {
        return provider.rx
            .request(.productDetail(productUUID: productUUID))
            .retryWhenDeliveryChanged()
            .map { response in

                guard let orderProductDetailResponse = try? response.map(OrderProductDetailResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = orderProductDetailResponse.error {
                    throw error
                }

                guard let data = orderProductDetailResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func getPromotions() -> Single<PromotionResult> {
        return provider.rx
            .request(.promotions)
            .retryWhenDeliveryChanged()
            .map { response in
                guard let promotionsResponse = try? response.map(PromotionsResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = promotionsResponse.error {
                    throw error
                }

                guard let promotions = promotionsResponse.data?.results else {
                    throw NetworkError.noData
                }

                return promotions
            }
    }

    func getPromotionDetail(by id: Int) -> Single<Promotion> {
        return provider.rx
            .request(.promotionDetail(id: id))
            .retryWhenDeliveryChanged()
            .map { response in

                guard let response = try? response.map(PromotionDetailResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = response.error {
                    throw error
                }

                guard let promotion = response.data else {
                    throw NetworkError.noData
                }

                return promotion
            }
    }
}
