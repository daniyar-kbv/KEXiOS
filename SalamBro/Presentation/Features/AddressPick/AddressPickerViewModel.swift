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
    private let repository: GeoRepository
    public var cellViewModels: [AddressPickerCellViewModelProtocol] = []
    private var addresses: [Address] = []
    
    let outputs = Output()

    public func didSelect(index: Int) {
        let address = addresses[index]
        repository.currentAddress = address
        outputs.didSelectAddress.accept(addresses[index])
    }

    init(repository: GeoRepository) {
        self.repository = repository
        
        reload()
    }
    
    func reload() {
        addresses = repository.addresses ?? []
        cellViewModels = repository.addresses?.map { AddressPickerCellViewModel(address: $0, isSelected: $0 == repository.currentAddress) } ?? []
        outputs.onReload.accept(())
    }
}

extension AddressPickerViewModel {
    struct Output {
        let didSelectAddress = PublishRelay<Address>()
        let onReload = PublishRelay<Void>()
    }
}
