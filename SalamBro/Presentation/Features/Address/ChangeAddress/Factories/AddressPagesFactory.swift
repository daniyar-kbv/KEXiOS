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
    func makeMapPage(userAddress: UserAddress) -> MapPage
    func makeBrandsPage(flowType: BrandViewModel.FlowType) -> BrandsController
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
        return scoped(.init(addressRepository: repositoryComponents.makeAddressRepository()))
    }

    func makeSelectMainInfoPage(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewController {
        return scoped(.init(viewModel: makeSelectMainInfoViewModel(flowType: flowType)))
    }

    private func makeSelectMainInfoViewModel(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewModel {
        return scoped(.init(addressRepository: repositoryComponents.makeAddressRepository(),
                            countriesRepository: repositoryComponents.makeCountriesRepository(),
                            citiesRepository: repositoryComponents.makeCitiesRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            defaultStorage: DefaultStorageImpl.sharedStorage,
                            flowType: flowType))
    }

    func makeMapPage(userAddress: UserAddress) -> MapPage {
        return scoped(.init(viewModel: makeMapViewModel(userAddress: userAddress)))
    }

    private func makeMapViewModel(userAddress: UserAddress) -> MapViewModel {
        return scoped(.init(defaultStorage: DefaultStorageImpl.sharedStorage,
                            addressRepository: repositoryComponents.makeAddressRepository(),
                            brandRepository: repositoryComponents.makeBrandRepository(),
                            flow: .change,
                            userAddress: userAddress))
    }

    func makeBrandsPage(flowType: BrandViewModel.FlowType) -> BrandsController {
        return scoped(.init(viewModel: makeBrandsViewModel(flowType: flowType)))
    }

    private func makeBrandsViewModel(flowType: BrandViewModel.FlowType) -> BrandViewModel {
        return scoped(.init(brandsRepository: repositoryComponents.makeBrandRepository(),
                            addressRepository: repositoryComponents.makeAddressRepository(),
                            flowType: flowType))
    }
}
