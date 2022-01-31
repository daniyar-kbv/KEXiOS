//
//  OnBoardingPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/9/21.
//

import Foundation

protocol OnBoadingPagesFactory: AnyObject {
    func makeCountriesPage() -> CountriesListController
    func makeCitiesPage(countryId: Int) -> CitiesListController
    func makeBrandsPage(flowType: BrandViewModel.FlowType) -> BrandsController
    func makeMapPage(userAddress: UserAddress) -> MapPage
}

final class OnBoardingPagesFactoryImpl: DependencyFactory, OnBoadingPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeCountriesPage() -> CountriesListController {
        return scoped(.init(viewModel: makeCountriesViewModel()))
    }

    private func makeCountriesViewModel() -> CountriesListViewModel {
        return scoped(.init(repository: repositoryComponents.makeCountriesRepository()))
    }

    func makeCitiesPage(countryId: Int) -> CitiesListController {
        return scoped(.init(viewModel: makeCitiesViewModel(countryId: countryId)))
    }

    private func makeCitiesViewModel(countryId: Int) -> CitiesListViewModel {
        return scoped(.init(countryId: countryId,
                            repository: repositoryComponents.makeCitiesRepository()))
    }

    func makeBrandsPage(flowType: BrandViewModel.FlowType) -> BrandsController {
        return scoped(.init(viewModel: makeBrandsViewModel(flowType: flowType)))
    }

    private func makeBrandsViewModel(flowType: BrandViewModel.FlowType) -> BrandViewModel {
        return scoped(.init(brandsRepository: repositoryComponents.makeBrandRepository(),
                            addressRepository: repositoryComponents.makeAddressRepository(),
                            flowType: flowType))
    }

    func makeMapPage(userAddress: UserAddress) -> MapPage {
        return scoped(.init(viewModel: makeMapViewModel(userAddress: userAddress)))
    }

    private func makeMapViewModel(userAddress: UserAddress) -> MapViewModel {
        return scoped(.init(defaultStorage: DefaultStorageImpl.sharedStorage,
                            addressRepository: repositoryComponents.makeAddressRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            flow: .creation,
                            userAddress: userAddress))
    }
}
