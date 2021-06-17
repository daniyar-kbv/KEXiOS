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

final class AddressPagesFactoryImpl: AddressPagesFactory {
    private var serviceComponents: ServiceComponents
    
    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }
    
    func makeAddressPickPage() -> AddressPickController {
        return .init(viewModel: makeAddressPickViewModel())
    }

    private func makeAddressPickViewModel() -> AddressPickerViewModel {
        return .init(locationRepository: getLocationRepository())
    }

    func makeSelectMainInfoPage(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewController {
        return .init(viewModel: makeSelectMainInfoViewModel(flowType: flowType))
    }

    private func makeSelectMainInfoViewModel(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewModel {
        return .init(locationService: getLocationService(),
                     locationRepository: getLocationRepository(),
                     brandRepository: getBrandRepository(),
                     flowType: flowType)
    }

    func makeMapPage(address: Address?) -> MapPage {
        return .init(viewModel: makeMapViewModel(address: address))
    }

    private func makeMapViewModel(address: Address?) -> MapViewModel {
        return .init(ordersService: serviceComponents.ordersService(),
                     defaultStorage: DefaultStorageImpl.sharedStorage,
                     locationRepository: getLocationRepository(),
                     brandRepository: getBrandRepository(),
                     flow: .change,
                     address: address)
    }

    func makeBrandsPage(cityId: Int) -> BrandsController {
        return .init(viewModel: makeBrandsViewModel(cityId: cityId),
                     flowType: .change)
    }

    private func makeBrandsViewModel(cityId: Int) -> BrandViewModel {
        return .init(repository: getBrandRepository(),
                     locationRepository: getLocationRepository(),
                     service: getLocationService(),
                     cityId: cityId)
    }
}

//  Tech debt: change to components

extension AddressPagesFactoryImpl {
    private func getLocationRepository() -> LocationRepository {
        return DIResolver.resolve(LocationRepository.self)!
    }

    private func getLocationService() -> LocationService {
        return DIResolver.resolve(LocationService.self)!
    }

    private func getBrandRepository() -> BrandRepository {
        return DIResolver.resolve(BrandRepository.self)!
    }
}
