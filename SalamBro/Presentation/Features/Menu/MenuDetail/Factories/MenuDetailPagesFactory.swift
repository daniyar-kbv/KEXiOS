//
//  MenuDetailPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/17/21.
//

import Foundation

protocol MenuDetailPagesFactory {
    func makeMenuDetailPage(positionUUID: String) -> MenuDetailController
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
                                              menuDetailRepository: repositoryComponents.makeMenuDetailRepository(),
                                              cartRepository: repositoryComponents.makeCartRepository()))
    }
}
