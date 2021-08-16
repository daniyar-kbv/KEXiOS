//
//  OrderHistoryPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol OrderHistoryPagesFactory: AnyObject {
    func makeOrderHistoryPage() -> OrderHistoryController
    func makeRateOrderPage() -> RateController
    func makeShareOrderPage() -> ShareOrderController // FIXME: Tect debt, rewrite this class
}

final class OrderHistoryPagesFactoryImpl: DependencyFactory, OrderHistoryPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeOrderHistoryPage() -> OrderHistoryController {
        return scoped(.init(viewModel: OrderHistoryViewModelImpl(
            ordersRepository: repositoryComponents.makeOrdersHistoryRepository())))
    }

    func makeRateOrderPage() -> RateController {
        return scoped(.init(viewModel: RateViewModelImpl(repository: repositoryComponents.makeRateOrderRepository())))
    }

    func makeShareOrderPage() -> ShareOrderController {
        return scoped(.init())
    }
}
