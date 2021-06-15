//
//  AddressListPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/11/21.
//

import Foundation

protocol AddressListPagesFactory {
    func makeAddressListPage() -> AddressListController
    func makeAddressDetailPage(deliveryAddress: DeliveryAddress) -> AddressDetailController
}

final class AddressListPagesFactoryImpl: AddressListPagesFactory {
    func makeAddressListPage() -> AddressListController {
        return .init(locationRepository: getLoactionRepository())
    }
    
    func makeAddressDetailPage(deliveryAddress: DeliveryAddress) -> AddressDetailController {
        return .init(deliveryAddress: deliveryAddress,
                     locationRepository: getLoactionRepository())
    }
}

//  Tech debt: change to components

extension AddressListPagesFactoryImpl {
    private func getLoactionRepository() -> LocationRepository {
        return DIResolver.resolve(LocationRepository.self)!
    }
}
