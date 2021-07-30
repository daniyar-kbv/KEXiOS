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

final class AddressPickerViewModel: AddressPickerViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let addressRepository: AddressRepository
    private var addresses: [UserAddress] = []

    var cellViewModels: [AddressPickerCellViewModelProtocol] = []
    let outputs = Output()

    init(addressRepository: AddressRepository) {
        self.addressRepository = addressRepository

        bindAddressRepository()
    }
}

extension AddressPickerViewModel {
    func didSelect(index: Int) {
        outputs.didSelectAddress.accept(addresses[index])
    }

    func reload() {
        addressRepository.getUserAddresses()
    }
}

extension AddressPickerViewModel {
    private func bindAddressRepository() {
        addressRepository.outputs
            .didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        addressRepository.outputs
            .didGetUserAddresses
            .subscribe(onNext: { [weak self] addresses in
                self?.process(userAddresses: addresses)
            })
            .disposed(by: disposeBag)
    }

    private func process(userAddresses: [UserAddress]) {
        addresses = userAddresses
        cellViewModels = userAddresses.map {
            AddressPickerCellViewModel(userAddress: $0,
                                       isSelected: $0 == addressRepository.getCurrentUserAddress())
        }
        outputs.onReload.accept(())
    }
}

extension AddressPickerViewModel {
    struct Output {
        let didGetError = PublishRelay<ErrorPresentable>()

        let didSelectAddress = PublishRelay<UserAddress>()
        let onReload = PublishRelay<Void>()
    }
}
