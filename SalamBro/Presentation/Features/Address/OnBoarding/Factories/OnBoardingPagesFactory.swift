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
    func makeBrandsPage(cityId: Int) -> BrandsController
    func makeMapPage() -> MapPage
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

    func makeBrandsPage(cityId: Int) -> BrandsController {
        return scoped(.init(viewModel: makeBrandsViewModel(cityId: cityId),
                            flowType: .create))
    }

    private func makeBrandsViewModel(cityId: Int) -> BrandViewModel {
        return scoped(.init(brandRepository: repositoryComponents.makeBrandRepository(), cityId: cityId))
    }

    func makeMapPage() -> MapPage {
        return scoped(.init(viewModel: makeMapViewModel()))
    }

    private func makeMapViewModel() -> MapViewModel {
        return scoped(.init(defaultStorage: DefaultStorageImpl.sharedStorage,
                            locationRepository: repositoryComponents.makeAddressRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            ordersRepository: repositoryComponents.makeOrdersRepository(),
                            flow: .creation))
    }
}
