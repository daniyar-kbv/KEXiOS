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

final class AddressListPagesFactoryImpl: DependencyFactory, AddressListPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeAddressListPage() -> AddressListController {
        return scoped(.init(locationRepository: repositoryComponents.makeLocationRepository()))
    }

    func makeAddressDetailPage(deliveryAddress: DeliveryAddress) -> AddressDetailController {
        return scoped(.init(deliveryAddress: deliveryAddress,
                            locationRepository: repositoryComponents.makeLocationRepository()))
    }
}
