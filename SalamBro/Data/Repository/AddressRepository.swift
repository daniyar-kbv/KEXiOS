//
//  AddressRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AddressRepository: AnyObject {
    var outputs: AddressRepositoryImpl.Output { get }

    func isAddressComplete() -> Bool

    func getCurrentCountry() -> Country?

    func getCurrentCity() -> City?

    func getCurrentAddress() -> Address?
    func changeCurrentAddress(to address: Address)

    func getDeliveryAddresses() -> [DeliveryAddress]?
    func setDeliveryAddressses(deliveryAddresses: [DeliveryAddress])
    func getCurrentDeliveryAddress() -> DeliveryAddress?
    func setCurrentDeliveryAddress(deliveryAddress: DeliveryAddress)
    func deleteDeliveryAddress(deliveryAddress: DeliveryAddress)
    func addDeliveryAddress(deliveryAddress: DeliveryAddress)

    func applyOrder(with dto: OrderApplyDTO)
}

final class AddressRepositoryImpl: AddressRepository {
    private(set) var outputs: Output = .init()

    private let storage: GeoStorage

    private let ordersService: OrdersService

    private let disposeBag = DisposeBag()

    init(storage: GeoStorage, ordersService: OrdersService) {
        self.storage = storage
        self.ordersService = ordersService
    }
}

extension AddressRepositoryImpl {
    func isAddressComplete() -> Bool {
        return getCurrentDeliveryAddress()?.isComplete() ?? false
    }
}

extension AddressRepositoryImpl {
    func getCurrentCountry() -> Country? {
        return getCurrentDeliveryAddress()?.country
    }
}

// MARK: Current city

extension AddressRepositoryImpl {
    func getCurrentCity() -> City? {
        return getCurrentDeliveryAddress()?.city
    }
}

//  MARK: Address

extension AddressRepositoryImpl {
    func getCurrentAddress() -> Address? {
        return getCurrentDeliveryAddress()?.address
    }

    func changeCurrentAddress(to address: Address) {
        if let index = storage.currentDeliveryAddressIndex {
            storage.deliveryAddresses[index].address = address
        } else {
            addDeliveryAddress(deliveryAddress: DeliveryAddress(address: address))
        }
    }
}

// MARK: DeliveryAddress

extension AddressRepositoryImpl {
    func getDeliveryAddresses() -> [DeliveryAddress]? {
        return storage.deliveryAddresses
    }

    func setDeliveryAddressses(deliveryAddresses: [DeliveryAddress]) {
        storage.deliveryAddresses = deliveryAddresses
    }

    func getCurrentDeliveryAddress() -> DeliveryAddress? {
        guard let index = storage.currentDeliveryAddressIndex else { return nil }
        return storage.deliveryAddresses[index]
    }

    func setCurrentDeliveryAddress(deliveryAddress: DeliveryAddress) {
        storage.currentDeliveryAddressIndex = storage.deliveryAddresses.firstIndex(where: { $0 == deliveryAddress })
    }

    func deleteDeliveryAddress(deliveryAddress: DeliveryAddress) {
        let wasCurrent = storage.currentDeliveryAddressIndex != nil &&
            storage.deliveryAddresses[storage.currentDeliveryAddressIndex!] == deliveryAddress
        storage.deliveryAddresses.removeAll(where: { $0 == deliveryAddress })
        storage.currentDeliveryAddressIndex = storage.deliveryAddresses.first != nil && wasCurrent ? 0 : nil
    }

    func addDeliveryAddress(deliveryAddress: DeliveryAddress) {
        storage.deliveryAddresses.append(deliveryAddress)
        storage.currentDeliveryAddressIndex = storage.deliveryAddresses.firstIndex(where: { $0 == deliveryAddress })
    }
}

extension AddressRepositoryImpl {
    func applyOrder(with dto: OrderApplyDTO) {
        outputs.didStartRequest.accept(())

        ordersService.applyOrder(dto: dto)
            .subscribe { [weak self] leadUUID in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetLeadUUID.accept(leadUUID)
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            }.disposed(by: disposeBag)
    }
}

extension AddressRepositoryImpl {
    struct Output {
        let didGetLeadUUID = PublishRelay<String>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
