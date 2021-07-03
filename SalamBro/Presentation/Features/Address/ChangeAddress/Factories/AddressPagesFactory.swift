//
//  AddressPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/9/21.
//

import Foundation

protocol AddressPagesFactory {
    func makeAddressPickPage() -> AddressPickController
    func makeSelectMainInfoPage(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewController
    func makeMapPage(address: Address?) -> MapPage
    func makeBrandsPage(cityId: Int) -> BrandsController
}

final class AddressPagesFactoryImpl: DependencyFactory, AddressPagesFactory {
    private var serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents)
    {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeAddressPickPage() -> AddressPickController {
        return scoped(.init(viewModel: makeAddressPickViewModel()))
    }

    private func makeAddressPickViewModel() -> AddressPickerViewModel {
        return scoped(.init(locationRepository: repositoryComponents.makeLocationRepository()))
    }

    func makeSelectMainInfoPage(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewController {
        return scoped(.init(viewModel: makeSelectMainInfoViewModel(flowType: flowType)))
    }

    private func makeSelectMainInfoViewModel(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewModel {
        return scoped(.init(locationService: serviceComponents.locationService(),
                            ordersService: serviceComponents.ordersService(),
                            locationRepository: repositoryComponents.makeLocationRepository(),
                            citiesRepository: repositoryComponents.makeCitiesRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            defaultStorage: DefaultStorageImpl.sharedStorage,
                            flowType: flowType))
    }

    func makeMapPage(address: Address?) -> MapPage {
        return scoped(.init(viewModel: makeMapViewModel(address: address)))
    }

    private func makeMapViewModel(address: Address?) -> MapViewModel {
        return scoped(.init(ordersService: serviceComponents.ordersService(),
                            defaultStorage: DefaultStorageImpl.sharedStorage,
                            locationRepository: repositoryComponents.makeLocationRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            flow: .change,
                            address: address))
    }

    func makeBrandsPage(cityId: Int) -> BrandsController {
        return scoped(.init(viewModel: makeBrandsViewModel(cityId: cityId),
                            flowType: .change))
    }

    private func makeBrandsViewModel(cityId: Int) -> BrandViewModel {
        return scoped(.init(repository: repositoryComponents.makeBrandRepository(),
                            locationRepository: repositoryComponents.makeLocationRepository(),
                            service: serviceComponents.locationService(),
                            cityId: cityId))
    }
}
