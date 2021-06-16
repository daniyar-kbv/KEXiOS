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

final class OnBoardingPagesFactoryImpl: OnBoadingPagesFactory {
    private var serviceComponents: ServiceComponents
    
    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }
    
    func makeCountriesPage() -> CountriesListController {
        return .init(viewModel: makeCountriesViewModel())
    }

    private func makeCountriesViewModel() -> CountriesListViewModel {
        return .init(service: getLocationService(),
                     repository: getLocationRepository())
    }

    func makeCitiesPage(countryId: Int) -> CitiesListController {
        return .init(viewModel: makeCitiesViewModel(countryId: countryId))
    }

    private func makeCitiesViewModel(countryId: Int) -> CitiesListViewModel {
        return .init(countryId: countryId,
                     service: getLocationService(),
                     repository: getLocationRepository())
    }

    func makeBrandsPage(cityId: Int) -> BrandsController {
        return .init(viewModel: makeBrandsViewModel(cityId: cityId),
                     flowType: .create)
    }

    private func makeBrandsViewModel(cityId: Int) -> BrandViewModel {
        return .init(repository: getBrandRepository(),
                     locationRepository: getLocationRepository(),
                     service: getLocationService(),
                     cityId: cityId)
    }

    func makeMapPage() -> MapPage {
        return .init(viewModel: makeMapViewModel())
    }

    private func makeMapViewModel() -> MapViewModel {
        return .init(ordersService: getOrdersService(),
                     locationRepository: getLocationRepository(),
                     brandRepository: getBrandRepository(),
                     flow: .creation)
    }
}

//  Tech debt: change to compoenents

extension OnBoardingPagesFactoryImpl {
    func getOrdersService() -> OrdersService {
        return serviceComponents.ordersService()
    }
    
    func getLocationService() -> LocationService {
        return DIResolver.resolve(LocationService.self)!
    }

    func getLocationRepository() -> LocationRepository {
        return DIResolver.resolve(LocationRepository.self)!
    }

    func getBrandRepository() -> BrandRepository {
        return DIResolver.resolve(BrandRepository.self)!
    }
}
