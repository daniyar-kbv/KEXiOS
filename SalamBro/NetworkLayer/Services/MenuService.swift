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
    func getPromotions(leadUUID: String) -> Single<[Promotion]>
    func getProducts(for leadUUID: String) -> Single<[MenuCategory]>
    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<MenuPositionDetail>
}

class MenuServiceImpl: MenuService {
    private let provider: MoyaProvider<MenuAPI>

    init(provider: MoyaProvider<MenuAPI>) {
        self.provider = provider
    }

    func getPromotions(leadUUID: String) -> Single<[Promotion]> {
        return provider.rx
            .request(.promotions(leadUUID: leadUUID))
            .map { response in
                guard let promotionsResponse = try? response.map(PromotionsResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let promotions = promotionsResponse.data?.results else {
                    throw NetworkError.noData
                }

                return promotions
            }
    }

    func getProducts(for leadUUID: String) -> Single<[MenuCategory]> {
        return provider.rx
            .request(.products(leadUUID: leadUUID))
            .map { response in

                guard let orderProductsResponse = try? response.map(OrderProductResponse.self) else {
                    throw NetworkError.badMapping
                }

                guard let data = orderProductsResponse.data?.categories else {
                    throw NetworkError.noData
                }

                return data
            }
    }

    func getProductDetail(for leadUUID: String, by productUUID: String) -> Single<MenuPositionDetail> {
        return provider.rx
            .request(.productDetail(leadUUID: leadUUID, productUUID: productUUID))
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
}
