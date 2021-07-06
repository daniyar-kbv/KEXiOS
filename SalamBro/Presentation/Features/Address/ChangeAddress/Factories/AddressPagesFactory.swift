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
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeAddressPickPage() -> AddressPickController {
        return scoped(.init(viewModel: makeAddressPickViewModel()))
    }

    private func makeAddressPickViewModel() -> AddressPickerViewModel {
        return scoped(.init(locationRepository: repositoryComponents.makeAddressRepository()))
    }

    func makeSelectMainInfoPage(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewController {
        return scoped(.init(viewModel: makeSelectMainInfoViewModel(flowType: flowType)))
    }

    private func makeSelectMainInfoViewModel(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewModel {
        return scoped(.init(locationRepository: repositoryComponents.makeAddressRepository(),
                            countriesRepository: repositoryComponents.makeCountriesRepository(),
                            citiesRepository: repositoryComponents.makeCitiesRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            ordersRepository: repositoryComponents.makeOrdersRepository(),
                            defaultStorage: DefaultStorageImpl.sharedStorage,
                            flowType: flowType))
    }

    func makeMapPage(address: Address?) -> MapPage {
        return scoped(.init(viewModel: makeMapViewModel(address: address)))
    }

    private func makeMapViewModel(address: Address?) -> MapViewModel {
        return scoped(.init(defaultStorage: DefaultStorageImpl.sharedStorage,
                            locationRepository: repositoryComponents.makeAddressRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            ordersRepository: repositoryComponents.makeOrdersRepository(),
                            flow: .change,
                            address: address))
    }

    func makeBrandsPage(cityId: Int) -> BrandsController {
        return scoped(.init(viewModel: makeBrandsViewModel(cityId: cityId),
                            flowType: .change))
    }

    private func makeBrandsViewModel(cityId: Int) -> BrandViewModel {
        return scoped(.init(brandRepository: repositoryComponents.makeBrandRepository(), cityId: cityId))
    }
}
