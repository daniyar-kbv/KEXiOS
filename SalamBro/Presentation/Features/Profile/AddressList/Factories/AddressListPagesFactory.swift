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
        return scoped(.init(viewModel: makeAddressListViewModel()))
    }

    private func makeAddressListViewModel() -> AddressListViewModel {
        return scoped(AddressListViewModelImpl(locationRepository: repositoryComponents.makeAddressRepository()))
    }

    func makeAddressDetailPage(deliveryAddress: DeliveryAddress) -> AddressDetailController {
        return scoped(.init(viewModel: makeAddressDetailViewModel(deliveryAddress: deliveryAddress)))
    }

    private func makeAddressDetailViewModel(deliveryAddress: DeliveryAddress) -> AddressDetailViewModel {
        return scoped(AddressDetailViewModelImpl(deliveryAddress: deliveryAddress, locationRepository: repositoryComponents.makeAddressRepository()))
    }
}
