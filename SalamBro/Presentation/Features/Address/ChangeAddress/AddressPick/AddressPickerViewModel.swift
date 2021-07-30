//
//  AddressPickerViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressPickerViewModelProtocol: ViewModel {
    var cellViewModels: [AddressPickerCellViewModelProtocol] { get }
    var outputs: AddressPickerViewModel.Output { get }
    func didSelect(index: Int)
    func reload()
}

final class AddressPickerViewModel: AddressPickerViewModelProtocol, Reloadable {
    private let locationRepository: AddressRepository
    public var cellViewModels: [AddressPickerCellViewModelProtocol] = []
    private var addresses: [DeliveryAddress] = []

    let outputs = Output()

    public func didSelect(index: Int) {
        let address = addresses[index]
        locationRepository.setCurrentDeliveryAddress(deliveryAddress: address)
        outputs.didSelectAddress.accept(addresses[index])
    }

    init(locationRepository: AddressRepository) {
        self.locationRepository = locationRepository

        reload()
    }

    func reload() {
        addresses = locationRepository.getDeliveryAddresses() ?? []
        cellViewModels = addresses.map {
            AddressPickerCellViewModel(deliveryAddress: $0,
                                       isSelected: $0 == locationRepository.getCurrentDeliveryAddress())
        }
        outputs.onReload.accept(())
    }
}

extension AddressPickerViewModel {
    struct Output {
        let didSelectAddress = PublishRelay<DeliveryAddress>()
        let onReload = PublishRelay<Void>()
    }
}
