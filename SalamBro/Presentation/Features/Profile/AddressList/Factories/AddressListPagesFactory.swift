//
//  AddressListPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/11/21.
//

import Foundation

protocol AddressListPagesFactory {
    func makeAddressListPage() -> AddressListController
    func makeAddressDetailPage(userAddress: UserAddress) -> AddressDetailController
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
        return scoped(AddressListViewModelImpl(addressRepository: repositoryComponents.makeAddressRepository()))
    }

    func makeAddressDetailPage(userAddress: UserAddress) -> AddressDetailController {
        return scoped(.init(viewModel: makeAddressDetailViewModel(userAddress: userAddress)))
    }

    private func makeAddressDetailViewModel(userAddress: UserAddress) -> AddressDetailViewModel {
        return scoped(AddressDetailViewModelImpl(userAddress: userAddress, addressRepository: repositoryComponents.makeAddressRepository()))
    }
}
