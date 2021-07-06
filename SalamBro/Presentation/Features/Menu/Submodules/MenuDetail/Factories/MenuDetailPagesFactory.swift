//
//  MenuDetailPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/17/21.
//

import Foundation

protocol MenuDetailPagesFactory {
    func makeMenuDetailPage(positionUUID: String) -> MenuDetailController
    func makeModifiersPage(modifierGroup: ModifierGroup) -> ModifiersController
}

class MenuDetailPagesFactoryImpl: DependencyFactory, MenuDetailPagesFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeMenuDetailPage(positionUUID: String) -> MenuDetailController {
        return scoped(.init(viewModel: makeMenuDetailViewModel(positionUUID: positionUUID)))
    }

    private func makeMenuDetailViewModel(positionUUID: String) -> MenuDetailViewModel {
        return scoped(MenuDetailViewModelImpl(positionUUID: positionUUID,
                                              defaultStorage: DefaultStorageImpl.sharedStorage,
                                              ordersRepository: repositoryComponents.makeOrdersRepository(),
                                              cartRepository: repositoryComponents.makeCartRepository()))
    }

    func makeModifiersPage(modifierGroup: ModifierGroup) -> ModifiersController {
        return scoped(.init(viewModel: makeModifiersViewModel(modifierGroup: modifierGroup)))
    }

    private func makeModifiersViewModel(modifierGroup: ModifierGroup) -> ModifiersViewModel {
        return scoped(ModifiersViewModelImpl(modifierGroup: modifierGroup))
    }
}
