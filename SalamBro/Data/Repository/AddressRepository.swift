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

    func getUserAddresses()
    func getCurrentUserAddress() -> UserAddress?
    func setCurrentUserAddress(to address: UserAddress)
    func updateUserAddress(with id: Int, brandId: Int)
    func deleteUserAddress(with id: Int)

    func applyOrder()
}

final class AddressRepositoryImpl: AddressRepository {
    private(set) var outputs: Output = .init()

    private let geoStorage: GeoStorage
    private let brandStorage: BrandStorage

    private let ordersService: OrdersService
    private let profileService: ProfileService
    private let notificationsService: PushNotificationsService

    private let defaultStorage: DefaultStorage

    private let disposeBag = DisposeBag()

    init(storage: GeoStorage,
         brandStorage: BrandStorage,
         ordersService: OrdersService,
         profileService: ProfileService,
         notificationsService: PushNotificationsService,
         defaultStorage: DefaultStorage)
    {
        geoStorage = storage
        self.brandStorage = brandStorage
        self.ordersService = ordersService
        self.profileService = profileService
        self.notificationsService = notificationsService
        self.defaultStorage = defaultStorage
    }
}

extension AddressRepositoryImpl {
    func isAddressComplete() -> Bool {
        return getCurrentUserAddress()?.isComplete() ?? false
    }
}

extension AddressRepositoryImpl {
    func getCurrentCountry() -> Country? {
        return getCurrentUserAddress()?.address.country
    }
}

// MARK: Current city

extension AddressRepositoryImpl {
    func getCurrentCity() -> City? {
        return getCurrentUserAddress()?.address.city
    }
}

//  MARK: Address

extension AddressRepositoryImpl {
    func getCurrentAddress() -> Address? {
        return getCurrentUserAddress()?.address
    }

    func changeCurrentAddress(to address: Address) {
        guard let index = geoStorage.userAddresses.firstIndex(where: { $0.isCurrent }) else { return }
        geoStorage.userAddresses[index].address = address
    }
}

// MARK: UserAddress

extension AddressRepositoryImpl {
    func getUserAddresses() {
        outputs.didGetUserAddresses.accept(geoStorage.userAddresses)
        outputs.didStartRequest.accept(())
        profileService.getAddresses()
            .subscribe(onSuccess: { [weak self] addresses in
                self?.outputs.didEndRequest.accept(())
                self?.geoStorage.userAddresses = addresses
                self?.outputs.didGetUserAddresses.accept(addresses)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func getCurrentUserAddress() -> UserAddress? {
        return geoStorage.userAddresses.first(where: { $0.isCurrent })
    }

    func setCurrentUserAddress(to address: UserAddress) {
        guard let id = address.id,
              let brandId = address.brandId else { return }
        let dto = UpdateAddressDTO(brandId: brandId)
        profileService.updateAddress(id: id, dto: dto)
            .subscribe(onSuccess: { [weak self] in
                self?.changeToCurrent(id: id)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func changeToCurrent(id: Int) {
        geoStorage.userAddresses.forEach { $0.isCurrent = $0.id == id }
    }

    func updateUserAddress(with id: Int, brandId: Int) {
        let dto = UpdateAddressDTO(brandId: brandId)
        profileService.updateAddress(id: id, dto: dto)
            .subscribe(onSuccess: { [weak self] in
                self?.changeToCurrent(id: id)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func deleteUserAddress(with _: Int) {
//        Tech debt: add logic
    }
}

extension AddressRepositoryImpl {
    func applyOrder() {
        guard let cityId = getCurrentCity()?.id,
              let longitude = getCurrentAddress()?.longitude.rounded(to: 8),
              let latitude = getCurrentAddress()?.latitude.rounded(to: 8),
              let brandId = brandStorage.brand?.id
        else { return }

        let dto = OrderApplyDTO(address: OrderApplyDTO.Address(city: cityId,
                                                               longitude: longitude,
                                                               latitude: latitude,
                                                               comment: getCurrentAddress()?.commentary),
                                localBrand: brandId)

        outputs.didStartRequest.accept(())

        ordersService.applyOrder(dto: dto)
            .subscribe { [weak self] leadUUID in
                self?.outputs.didEndRequest.accept(())
                self?.defaultStorage.persist(leadUUID: leadUUID)
                self?.fcmTokenCreate()
                self?.outputs.didGetLeadUUID.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            }.disposed(by: disposeBag)
    }
}

extension AddressRepositoryImpl {
    private func fcmTokenCreate() {
        guard let leadUUID = defaultStorage.leadUUID,
              let fcmToken = defaultStorage.fcmToken else { return }

        let dto = FCMTokenCreateDTO(leadUUID: leadUUID, fcmToken: fcmToken)

        notificationsService.fcmTokenCreate(dto: dto)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension AddressRepositoryImpl {
    struct Output {
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()

        let didGetLeadUUID = PublishRelay<Void>()
        let didGetUserAddresses = PublishRelay<[UserAddress]>()
    }
}
