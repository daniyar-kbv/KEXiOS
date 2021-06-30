//
//  AddressDetailViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/1/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressDetailViewModel {
    var outputs: AddressDetailViewModelImpl.Output { get }

    func delete()
}

final class AddressDetailViewModelImpl: AddressDetailViewModel {
    private let deliveryAddress: DeliveryAddress
    private let locationRepository: LocationRepository

    let outputs: Output

    init(deliveryAddress: DeliveryAddress,
         locationRepository: LocationRepository)
    {
        self.deliveryAddress = deliveryAddress
        self.locationRepository = locationRepository
        outputs = .init(deliveryAddress: deliveryAddress,
                        locationRepository: locationRepository)
    }

    func delete() {
        locationRepository.deleteDeliveryAddress(deliveryAddress: deliveryAddress)
        outputs.didDelete.accept(())
    }
}

extension AddressDetailViewModelImpl {
    struct Output {
        let addressName: BehaviorRelay<String?>
        let comment: BehaviorRelay<String?>
        let isCurrent: BehaviorRelay<Bool>

        let didDelete = PublishRelay<Void>()

        init(deliveryAddress: DeliveryAddress,
             locationRepository: LocationRepository)
        {
            addressName = .init(value: deliveryAddress.address?.name)
            comment = .init(value: deliveryAddress.address?.commentary)
            isCurrent = .init(value: deliveryAddress == locationRepository.getCurrentDeliveryAddress())
        }
    }
}
