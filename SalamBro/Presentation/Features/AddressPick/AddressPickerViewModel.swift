//
//  AddressPickerViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

public protocol AddressPickerViewModelProtocol: AnyObject {
    var cellViewModels: [AddressPickerCellViewModelProtocol] { get }
    func didSelect(index: Int) -> Address
}

public final class AddressPickerViewModel: AddressPickerViewModelProtocol {
    private let repository: GeoRepository
    public var cellViewModels: [AddressPickerCellViewModelProtocol]
    private let addresses: [Address]

    public func didSelect(index: Int) -> Address {
        let address = addresses[index]
        repository.currentAddress = address
        return address
    }

    public init(repository: GeoRepository) {
        self.repository = repository
        addresses = repository.addresses ?? []
        cellViewModels = repository.addresses?.map { AddressPickerCellViewModel(address: $0, isSelected: $0 == repository.currentAddress) } ?? []
    }
}
