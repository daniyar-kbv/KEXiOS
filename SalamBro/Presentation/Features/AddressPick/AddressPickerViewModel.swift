//
//  AddressPickerViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

protocol AddressPickerViewModelProtocol: ViewModel {
    var cellViewModels: [AddressPickerCellViewModelProtocol] { get }
    func didSelect(index: Int)
    func changeAddress()
}

final class AddressPickerViewModel: AddressPickerViewModelProtocol {
    public var router: Router
    private let repository: GeoRepository
    public var cellViewModels: [AddressPickerCellViewModelProtocol]
    private let addresses: [Address]
    private let didSelectAddress: ((Address) -> Void)?

    public func didSelect(index: Int) {
        let address = addresses[index]
        repository.currentAddress = address
        didSelectAddress?(addresses[index])
        close()
    }

    public func changeAddress() {
        router.enqueueRoute(with: AddressPickerRouter.RouteType.changeAddress, animated: true, completion: nil)
    }

    init(router: Router,
         repository: GeoRepository,
         didSelectAddress: ((Address) -> Void)?)
    {
        self.router = router
        self.repository = repository
        self.didSelectAddress = didSelectAddress
        addresses = repository.addresses ?? []
        cellViewModels = repository.addresses?.map { AddressPickerCellViewModel(address: $0, isSelected: $0 == repository.currentAddress) } ?? []
    }
}
