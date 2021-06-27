//
//  CartPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 14.06.2021.
//

import Foundation

protocol CartPagesFactory: AnyObject {
    func makeCartPage() -> CartController
}

final class CartPagesFactoryImpl: DependencyFactory, CartPagesFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeCartPage() -> CartController {
        return scoped(.init(viewModel: makeCartViewModel()))
    }

    private func makeCartViewModel() -> CartViewModel {
        return scoped(CartViewModelImpl(cartRepository: repositoryComponents.makeCartRepository()))
    }
}
