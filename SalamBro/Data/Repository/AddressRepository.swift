//
//  AddressRepository.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

protocol AddressRepository: AnyObject {
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
}

final class LocationRepositoryImpl: AddressRepository {
    private let storage: GeoStorage

    init(storage: GeoStorage) {
        self.storage = storage
    }
}

extension LocationRepositoryImpl {
    func isAddressComplete() -> Bool {
        return getCurrentDeliveryAddress()?.isComplete() ?? false
    }
}

extension LocationRepositoryImpl {
    func getCurrentCountry() -> Country? {
        return getCurrentDeliveryAddress()?.country
    }
}

// MARK: Current city

extension LocationRepositoryImpl {
    func getCurrentCity() -> City? {
        return getCurrentDeliveryAddress()?.city
    }
}

//  MARK: Address

extension LocationRepositoryImpl {
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

extension LocationRepositoryImpl {
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
