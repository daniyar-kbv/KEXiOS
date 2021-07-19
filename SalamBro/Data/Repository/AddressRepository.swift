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

    func applyOrder(withAddress: Bool)
}

final class AddressRepositoryImpl: AddressRepository {
    private(set) var outputs: Output = .init()

    private let geoStorage: GeoStorage
    private let brandStorage: BrandStorage
    private let defaultStorage: DefaultStorage

    private let ordersService: OrdersService

    private let disposeBag = DisposeBag()

    init(storage: GeoStorage,
         brandStorage: BrandStorage,
         defaultStorage: DefaultStorage,
         ordersService: OrdersService)
    {
        geoStorage = storage
        self.brandStorage = brandStorage
        self.defaultStorage = defaultStorage
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
        if let index = geoStorage.currentDeliveryAddressIndex {
            geoStorage.deliveryAddresses[index].address = address
        } else {
            addDeliveryAddress(deliveryAddress: DeliveryAddress(address: address))
        }
    }
}

// MARK: DeliveryAddress

extension AddressRepositoryImpl {
    func getDeliveryAddresses() -> [DeliveryAddress]? {
        return geoStorage.deliveryAddresses
    }

    func setDeliveryAddressses(deliveryAddresses: [DeliveryAddress]) {
        geoStorage.deliveryAddresses = deliveryAddresses
    }

    func getCurrentDeliveryAddress() -> DeliveryAddress? {
        guard let index = geoStorage.currentDeliveryAddressIndex else { return nil }
        return geoStorage.deliveryAddresses[index]
    }

    func setCurrentDeliveryAddress(deliveryAddress: DeliveryAddress) {
        geoStorage.currentDeliveryAddressIndex = geoStorage.deliveryAddresses.firstIndex(where: { $0 == deliveryAddress })
    }

    func deleteDeliveryAddress(deliveryAddress: DeliveryAddress) {
        let wasCurrent = geoStorage.currentDeliveryAddressIndex != nil &&
            geoStorage.deliveryAddresses[geoStorage.currentDeliveryAddressIndex!] == deliveryAddress
        geoStorage.deliveryAddresses.removeAll(where: { $0 == deliveryAddress })
        geoStorage.currentDeliveryAddressIndex = geoStorage.deliveryAddresses.first != nil && wasCurrent ? 0 : nil
    }

    func addDeliveryAddress(deliveryAddress: DeliveryAddress) {
        geoStorage.deliveryAddresses.append(deliveryAddress)
        geoStorage.currentDeliveryAddressIndex = geoStorage.deliveryAddresses.firstIndex(where: { $0 == deliveryAddress })
    }
}

extension AddressRepositoryImpl {
    func applyOrder(withAddress: Bool = true) {
        var dto: OrderApplyDTO?

        if withAddress {
            guard let cityId = getCurrentCity()?.id,
                  let longitude = getCurrentAddress()?.longitude.rounded(to: 8),
                  let latitude = getCurrentAddress()?.latitude.rounded(to: 8),
                  let brandId = brandStorage.brand?.id
            else { return }

            dto = OrderApplyDTO(address: OrderApplyDTO.Address(city: cityId,
                                                               longitude: longitude,
                                                               latitude: latitude),
                                localBrand: brandId)
        }

        outputs.didStartRequest.accept(())

        ordersService.applyOrder(dto: dto)
            .subscribe { [weak self] leadUUID in
                self?.outputs.didEndRequest.accept(())
                self?.process(leadUUID: leadUUID)
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            }.disposed(by: disposeBag)
    }

    private func process(leadUUID: String) {
        defaultStorage.persist(leadUUID: leadUUID)
        outputs.didGetLeadUUID.accept(())
    }
}

extension AddressRepositoryImpl {
    struct Output {
        let didGetLeadUUID = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
