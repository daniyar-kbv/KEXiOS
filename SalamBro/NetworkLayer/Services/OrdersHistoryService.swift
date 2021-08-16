//
//  OrdersHistoryService.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/13/21.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol OrdersHistoryService: AnyObject {
    func getOrders() -> Single<[OrdersList]>
}

final class OrdersHistoryServiceMoyaImpl: OrdersHistoryService {
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
}
