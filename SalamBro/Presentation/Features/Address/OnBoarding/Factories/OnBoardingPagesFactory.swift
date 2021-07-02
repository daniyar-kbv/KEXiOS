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
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeCountriesPage() -> CountriesListController {
        return scoped(.init(viewModel: makeCountriesViewModel()))
    }

    private func makeCountriesViewModel() -> CountriesListViewModel {
        return scoped(.init(service: serviceComponents.locationService(),
                            repository: repositoryComponents.makeLocationRepository()))
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
        return scoped(.init(repository: repositoryComponents.makeBrandRepository(),
                            locationRepository: repositoryComponents.makeLocationRepository(),
                            service: serviceComponents.locationService(),
                            cityId: cityId))
    }

    func makeMapPage() -> MapPage {
        return scoped(.init(viewModel: makeMapViewModel()))
    }

    private func makeMapViewModel() -> MapViewModel {
        return scoped(.init(ordersService: serviceComponents.ordersService(),
                            defaultStorage: DefaultStorageImpl.sharedStorage,
                            locationRepository: repositoryComponents.makeLocationRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            flow: .creation))
    }
}
