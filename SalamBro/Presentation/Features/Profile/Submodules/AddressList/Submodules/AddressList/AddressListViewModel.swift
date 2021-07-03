//
//  AddressListViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/1/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressListViewModel {
    var outputs: AddressListViewModelImpl.Output { get }
    var deliveryAddresses: [DeliveryAddress] { get set }

    func getAddresses()
}

final class AddressListViewModelImpl: AddressListViewModel {
    private let locationRepository: AddressRepository

    let outputs = Output()

    var deliveryAddresses = [DeliveryAddress]()

    init(locationRepository: AddressRepository) {
        self.locationRepository = locationRepository
    }

    func getAddresses() {
        deliveryAddresses = locationRepository.getDeliveryAddresses() ?? []
        outputs.reload.accept(())
    }
}

extension AddressListViewModelImpl {
    struct Output {
        let reload = PublishRelay<Void>()
    }
}
