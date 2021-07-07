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
    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data>
}

final class MenuRepositoryImpl: MenuRepository {
    private let disposeBag = DisposeBag()
    private let ordersService: OrdersService

    init(ordersService: OrdersService) {
        self.ordersService = ordersService
    }

    func getProducts(for leadUUID: String) -> Single<OrderProductResponse.Data> {
        return ordersService.getProducts(for: leadUUID)
    }
}
