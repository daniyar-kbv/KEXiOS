//
//  OrderHistoryPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

protocol OrderHistoryPagesFactory: AnyObject {
    func makeOrderHistoryPage() -> OrderHistoryController // FIXME: Tech debt, rewrite this class
    func makeRateOrderPage() -> RateController // FIXME: Tech debt, rewrite this class
    func makeShareOrderPage() -> ShareOrderController // FIXME: Tect debt, rewrite this class
}

final class OrderHistoryPagesFactoryImpl: DependencyFactory, OrderHistoryPagesFactory {
    func makeOrderHistoryPage() -> OrderHistoryController {
        return scoped(.init(viewModel: makeOrderHistoryViewModel()))
    }

    private func makeOrderHistoryViewModel() -> OrderHistoryViewModel {
        return scoped(OrderHistoryViewModelImpl())
    }

    func makeRateOrderPage() -> RateController {
        return scoped(.init())
    }

    func makeShareOrderPage() -> ShareOrderController {
        return scoped(.init())
    }
}
