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
    func getOrders(page: Int) -> Single<OrdersListResponse.Data>
}

final class OrdersHistoryServiceMoyaImpl: OrdersHistoryService {
    private let provider: MoyaProvider<OrdersAPI>

    init(provider: MoyaProvider<OrdersAPI>) {
        self.provider = provider
    }

    func getOrders(page: Int) -> Single<OrdersListResponse.Data> {
        return provider.rx
            .request(.getAllOrders(page: page))
            .retryWhenDeliveryChanged()
            .map { response in
                guard let ordersResponse = try? response.map(OrdersListResponse.self) else {
                    throw NetworkError.badMapping
                }

                if let error = ordersResponse.error {
                    throw error
                }

                guard let data = ordersResponse.data else {
                    throw NetworkError.noData
                }

                return data
            }
    }
}
