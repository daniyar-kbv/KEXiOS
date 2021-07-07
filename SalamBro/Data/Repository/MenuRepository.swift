//
//  MenuRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuRepository: AnyObject {
    func getPromotions() -> Single<[Promotion]>
    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data>
}

final class MenuRepositoryImpl: MenuRepository {
    private let disposeBag = DisposeBag()
    private let ordersService: OrdersService
    private let promotionsService: PromotionsService

    init(ordersService: OrdersService, promotionsService: PromotionsService) {
        self.ordersService = ordersService
        self.promotionsService = promotionsService
    }

    func getPromotions() -> Single<[Promotion]> {
        return promotionsService.getPromotions()
    }

    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data> {
        return ordersService.getProducts(for: leadUUID)
    }
}
