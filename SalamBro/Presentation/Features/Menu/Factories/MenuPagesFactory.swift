//
//  MenuPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

protocol MenuPagesFactory {
    func makeManuPage() -> MenuController
    func makePromotionsPage(url: URL, name: String?, urlString: String) -> PromotionsController
}

class MenuPagesFactoryIml: DependencyFactory, MenuPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeManuPage() -> MenuController {
        return scoped(.init(viewModel: makeMenuViewModel()))
    }

    private func makeMenuViewModel() -> MenuViewModelProtocol {
        return scoped(MenuViewModel(locationRepository: repositoryComponents.makeAddressRepository(),
                                    brandRepository: repositoryComponents.makeBrandRepository(),
                                    menuRepository: repositoryComponents.makeMenuRepository(),
                                    defaultStorage: DefaultStorageImpl.sharedStorage,
                                    tokenStorage: AuthTokenStorageImpl.sharedStorage,
                                    scrollService: .init()))
    }

    func makePromotionsPage(url: URL, name: String?, urlString: String) -> PromotionsController {
        return scoped(.init(viewModel: makePromotionsViewModel(url: url, name: name, urlString: urlString)))
    }

    private func makePromotionsViewModel(url: URL, name: String?, urlString: String) -> PromotionsViewModel {
        return scoped(PromotionsViewModelImpl(input: .init(url: url,
                                                           name: name,
                                                           redirectURL: urlString),
                                              authTokenStorage: AuthTokenStorageImpl.sharedStorage,
                                              defaultStorage: DefaultStorageImpl.sharedStorage))
    }
}
