//
//  AddressPickerViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

protocol AddressPickerViewModelProtocol: ViewModel {
    var coordinator: AddressCoordinator { get }
    var cellViewModels: [AddressPickerCellViewModelProtocol] { get }
    func didSelect(index: Int, completion: () -> Void)
    func changeAddress()
    func onFinish()
}

final class AddressPickerViewModel: AddressPickerViewModelProtocol {
    public var coordinator: AddressCoordinator
    private let repository: GeoRepository
    public var cellViewModels: [AddressPickerCellViewModelProtocol]
    private let addresses: [Address]
    private let didSelectAddress: ((Address) -> Void)?

    public func didSelect(index: Int, completion: () -> Void) {
        let address = addresses[index]
        repository.currentAddress = address
        didSelectAddress?(addresses[index])
        completion()
    }

    public func changeAddress() {
        coordinator.openSelectMainInfo(didSave: nil)
    }

    init(coordinator: AddressCoordinator,
         repository: GeoRepository,
         didSelectAddress: ((Address) -> Void)?)
    {
        self.coordinator = coordinator
        self.repository = repository
        self.didSelectAddress = didSelectAddress
        addresses = repository.addresses ?? []
        cellViewModels = repository.addresses?.map { AddressPickerCellViewModel(address: $0, isSelected: $0 == repository.currentAddress) } ?? []
    }
    
    func onFinish() {
        coordinator.didFinish()
    }
}
