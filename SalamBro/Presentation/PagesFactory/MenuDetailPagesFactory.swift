//
//  MenuDetailPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/17/21.
//

import Foundation

protocol MenuDetailPagesFactory {
    func makeMenuDetailPage(positionUUID: String) -> MenuDetailController
    func makeModifiersPage() -> ModifiersController
}

class MenuDetailPagesFactoryImpl: MenuDetailPagesFactory {
    private let serviceComponents: ServiceComponents
    
    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }
    
    func makeMenuDetailPage(positionUUID: String) -> MenuDetailController {
        return .init(viewModel: makeMenuDetailViewModel(positionUUID: positionUUID))
    }
    
    private func makeMenuDetailViewModel(positionUUID: String) -> MenuDetailViewModel {
        return  MenuDetailViewModelImpl(productUUID: positionUUID,
                                        defaultStorage: DefaultStorageImpl.sharedStorage,
                                        ordersService: serviceComponents.ordersService())
    }
    
    func makeModifiersPage() -> ModifiersController {
        return .init(viewModel: makeModifiersViewModel())
    }
    
    private func makeModifiersViewModel() -> ModifiersViewModel {
        return ModifiersViewModelImpl()
    }
}
