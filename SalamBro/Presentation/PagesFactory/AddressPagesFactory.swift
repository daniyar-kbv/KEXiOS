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
    func makeMapPage() -> MapPage
    func makeBrandsPage() -> BrandsController
}

class AddressPagesFactoryImpl: AddressPagesFactory {
    func makeAddressPickPage() -> AddressPickController {
        return .init(viewModel: makeAddressPickViewModel())
    }
    
    private func makeAddressPickViewModel() -> AddressPickerViewModel {
        return .init(repository: DIResolver.resolve(GeoRepository.self)!)
    }
    
    func makeSelectMainInfoPage(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewController {
        return .init(viewModel: makeSelectMainInfoViewModel(flowType: flowType),
                     flowType: flowType)
    }
    
    private func makeSelectMainInfoViewModel(flowType: SelectMainInformationViewModel.FlowType) -> SelectMainInformationViewModel {
        return .init(geoRepository: DIResolver.resolve(GeoRepository.self)!,
                     brandRepository: DIResolver.resolve(BrandRepository.self)!,
                     flowType: flowType)
    }
    
    func makeMapPage() -> MapPage {
        return .init(viewModel: makeMapViewModel())
    }
    
    private func makeMapViewModel() -> MapViewModel {
        return .init(flow: .creation)
    }
    
    func makeBrandsPage() -> BrandsController {
        return .init(viewModel: makeBrandsViewModel(),
                     flowType: .change)
    }
    
    private func makeBrandsViewModel() -> BrandViewModel {
        return .init(repository: DIResolver.resolve(BrandRepository.self)!,
                     locationRepository: DIResolver.resolve(LocationRepository.self)!,
                     service: DIResolver.resolve(LocationService.self)!)
    }
}
