//
//  ChangeAddressViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 19.05.2021.
//

import Foundation

protocol ChangeAddressViewModel: AnyObject {
    func getCellModel(for indexPath: IndexPath) -> ChangeAddressDTO
    func getCellsCount() -> Int
}

final class ChangeAddressViewModelImpl: ChangeAddressViewModel {
    private let router: Router

    private(set) var cellModels: [ChangeAddressDTO] = [
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .country),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .city),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .disclosureIndicator, inputType: .address),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .none, inputType: .empty),
        ChangeAddressDTO(isSelected: false, description: nil, accessoryType: .disclosureIndicator, inputType: .brand),
    ]

    init(router: Router) {
        self.router = router
    }

    func getCellModel(for indexPath: IndexPath) -> ChangeAddressDTO {
        return cellModels[indexPath.row]
    }

    func getCellsCount() -> Int {
        return cellModels.count
    }

    func changeRoute(indexPath: IndexPath, completion _: (String) -> Void) {
        let cellModel = cellModels[indexPath.row]

        switch cellModel.inputType {
        case .address: break
        case .brand: break
        case .city:
//            router.enqueueRoute(with: <#T##Any?#>)

        case .country: break
        case .empty: break
        }
    }
}
