//
//  AddressPickerViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol AddressPickerViewModelProtocol: ViewModel {
    var cellViewModels: [AddressPickerCellViewModelProtocol] { get }
    var outputs: AddressPickerViewModel.Output { get }
    func didSelect(index: Int)
    func reload()
}

final class AddressPickerViewModel: AddressPickerViewModelProtocol {
    private let locationRepository: LocationRepository
    public var cellViewModels: [AddressPickerCellViewModelProtocol] = []
    private var addresses: [DeliveryAddress] = []
    
    let outputs = Output()

    public func didSelect(index: Int) {
        let address = addresses[index]
        locationRepository.setCurrentDeliveryAddress(deliveryAddress: address)
        outputs.didSelectAddress.accept(addresses[index])
    }

    init(locationRepository: LocationRepository) {
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
