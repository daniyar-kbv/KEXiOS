//
//  MenuPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

protocol MenuPagesFactory {
    func makeManuPage() -> MenuController
    func makePromotionsPage(url: URL, name: String?) -> AgreementController
}

class MenuPagesFactoryIml: DependencyFactory, MenuPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeManuPage() -> MenuController {
        return scoped(.init(viewModel: makeMenuViewModel(),
                            scrollService: MenuScrollService()))
    }

    private func makeMenuViewModel() -> MenuViewModelProtocol {
        return scoped(MenuViewModel(locationRepository: repositoryComponents.makeAddressRepository(),
                                    brandRepository: repositoryComponents.makeBrandRepository(),
                                    menuRepository: repositoryComponents.makeMenuRepository(),
                                    defaultStorage: DefaultStorageImpl.sharedStorage,
                                    tokenStorage: AuthTokenStorageImpl.sharedStorage))
    }

    func makePromotionsPage(url: URL, name: String?) -> AgreementController {
        return scoped(.init(viewModel: makePromotionsViewModel(url: url, name: name)))
    }

    private func makePromotionsViewModel(url: URL, name: String?) -> AgreementViewModel {
        return scoped(AgreementViewModelImpl(input: .init(url: url, name: name)))
    }
}
