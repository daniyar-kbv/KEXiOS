//
//  OrderHistoryPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol OrderHistoryPagesFactory: AnyObject {
    func makeOrderHistoryPage() -> OrderHistoryController
    func makeRateOrderPage(for rateID: Int) -> RateController
    func makeShareOrderPage(with url: String) -> ShareOrderController
}

final class OrderHistoryPagesFactoryImpl: DependencyFactory, OrderHistoryPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeOrderHistoryPage() -> OrderHistoryController {
        return scoped(.init(viewModel: OrderHistoryViewModelImpl(
            ordersRepository: repositoryComponents.makeOrdersHistoryRepository(),
            storage: makeLocalStorage()
        )))
    }

    func makeRateOrderPage(for rateID: Int) -> RateController {
        return scoped(.init(viewModel: RateViewModelImpl(
            repository: repositoryComponents.makeRateOrderRepository(),
            rateID: rateID
        ))
        )
    }

    func makeShareOrderPage(with url: String) -> ShareOrderController {
        return scoped(.init(viewModel: ShareOrderViewModelImpl(url: url)))
    }

    private func makeLocalStorage() -> Storage {
        return shared(.init())
    }
}
