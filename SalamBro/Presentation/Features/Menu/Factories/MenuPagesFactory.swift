//
//  MenuPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

protocol MenuPagesFactory {
    func makeManuPage() -> MenuController
    func makePromotionsPage(url: URL, name: String) -> AgreementController
}

class MenuPagesFactoryIml: DependencyFactory, MenuPagesFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeManuPage() -> MenuController {
        return scoped(.init(viewModel: makeMenuViewModel(),
                            scrollService: MenuScrollService()))
    }

    private func makeMenuViewModel() -> MenuViewModelProtocol {
        return scoped(MenuViewModel(defaultStorage: DefaultStorageImpl.sharedStorage,
                                    promotionsService: serviceComponents.promotionsService(),
                                    locationRepository: repositoryComponents.makeAddressRepository(),
                                    brandRepository: repositoryComponents.makeBrandRepository(),
                                    menuRepository: repositoryComponents.makeMenuRepository()))
    }

    func makePromotionsPage(url: URL, name: String) -> AgreementController {
        return scoped(.init(viewModel: makePromotionsViewModel(url: url, name: name)))
    }

    private func makePromotionsViewModel(url: URL, name: String) -> AgreementViewModel {
        return scoped(AgreementViewModelImpl(input: .init(url: url, name: name)))
    }
}
