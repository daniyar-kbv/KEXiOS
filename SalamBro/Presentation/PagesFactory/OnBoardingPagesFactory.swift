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
    func makeBrandsPage() -> BrandsController
    func makeMapPage() -> MapPage
}

class OnBoardingPagesFactoryImpl: OnBoadingPagesFactory {
    func makeCountriesPage() -> CountriesListController {
        return .init(viewModel: makeCountriesViewModel())
    }
    
    private func makeCountriesViewModel() -> CountriesListViewModel {
        return .init(service: DIResolver.resolve(LocationService.self)!,
                     repository: DIResolver.resolve(LocationRepository.self)!)
    }
    
    func makeCitiesPage(countryId: Int) -> CitiesListController {
        return .init(viewModel: makeCitiesViewModel(countryId: countryId))
    }
    
    private func makeCitiesViewModel(countryId: Int) -> CitiesListViewModel {
        return .init(countryId: countryId,
                     service: DIResolver.resolve(LocationService.self)!,
                     repository: DIResolver.resolve(LocationRepository.self)!)
    }
    
    func makeBrandsPage() -> BrandsController {
        return .init(viewModel: makeBrandsViewModel(),
                     flowType: .create)
    }
    
    private func makeBrandsViewModel() -> BrandViewModel {
        return .init(repository: DIResolver.resolve(BrandRepository.self)!,
                     locationRepository: DIResolver.resolve(LocationRepository.self)!,
                     service: DIResolver.resolve(LocationService.self)!)
    }
    
    func makeMapPage() -> MapPage {
        return .init(viewModel: makeMapViewModel())
    }
    
    private func makeMapViewModel() -> MapViewModel {
        return .init(flow: .creation)
    }
}
