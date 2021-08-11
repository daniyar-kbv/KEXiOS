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
    func changeCurrentAddress(district: String?, street: String?, building: String?, corpus: String?, flat: String?, comment: String?, longitude: Double?, latitude: Double?)

    func getUserAddresses()
    func getCurrentUserAddress() -> UserAddress?
    func setInitial(userAddress: UserAddress)
    func create(userAddress: UserAddress)
    func updateUserAddress(with id: Int, brandId: Int)
    func deleteUserAddress(with id: Int)
}

final class AddressRepositoryImpl: AddressRepository {
    private(set) var outputs: Output = .init()

    private let geoStorage: GeoStorage
    private let authService: AuthService
    private let brandStorage: BrandStorage
    private let defaultStorage: DefaultStorage
    private let authTokenStorage: AuthTokenStorage

    private let ordersService: OrdersService
    private let authorizedApplyService: AuthorizedApplyService
    private let profileService: ProfileService

    private let disposeBag = DisposeBag()

    init(storage: GeoStorage,
         authService: AuthService,
         brandStorage: BrandStorage,
         ordersService: OrdersService,
         authorizedApplyService: AuthorizedApplyService,
         profileService: ProfileService,
         defaultStorage: DefaultStorage,
         authTokenStorage: AuthTokenStorage)
    {
        geoStorage = storage
        self.authService = authService
        self.brandStorage = brandStorage
        self.ordersService = ordersService
        self.authorizedApplyService = authorizedApplyService
        self.profileService = profileService
        self.defaultStorage = defaultStorage
        self.authTokenStorage = authTokenStorage

        bindNotifications()
    }
}

extension AddressRepositoryImpl {
    private func bindNotifications() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.leadUUID.name)
            .subscribe(onNext: { [weak self] in
                guard let leadUUID = $0.object as? String else { return }
                self?.process(leadUUID: leadUUID)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.userAddresses.name)
            .subscribe(onNext: { [weak self] in
                guard let userAddresses = $0.object as? [UserAddress] else { return }
                self?.process(userAddresses: userAddresses)
            })
            .disposed(by: disposeBag)
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

    func changeCurrentAddress(district: String?,
                              street: String?,
                              building: String?,
                              corpus: String?,
                              flat: String?,
                              comment: String?,
                              longitude: Double?,
                              latitude: Double?)
    {
        guard let index = geoStorage.userAddresses.firstIndex(where: { $0.isCurrent }) else { return }
        let userAddresses = geoStorage.userAddresses
        userAddresses[index].address.district = district
        userAddresses[index].address.street = street
        userAddresses[index].address.building = building
        userAddresses[index].address.corpus = corpus
        userAddresses[index].address.flat = flat
        userAddresses[index].address.comment = comment
        userAddresses[index].address.longitude = longitude
        userAddresses[index].address.latitude = latitude
        geoStorage.userAddresses = userAddresses
    }
}

// MARK: UserAddress

extension AddressRepositoryImpl {
    func getUserAddresses() {
        outputs.didGetUserAddresses.accept(geoStorage.userAddresses)
        outputs.didStartRequest.accept(())
        profileService.getAddresses()
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] addresses in
                self?.process(userAddresses: addresses)
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(userAddresses: [UserAddress]) {
        geoStorage.userAddresses = userAddresses
        outputs.didGetUserAddresses.accept(userAddresses)
    }

    func getCurrentUserAddress() -> UserAddress? {
        return geoStorage.userAddresses.first(where: { $0.isCurrent })
    }

    func setInitial(userAddress: UserAddress) {
        guard let dto = userAddress.toDTO() else { return }
        outputs.didStartRequest.accept(())
        ordersService.applyOrder(dto: dto)
            .subscribe(onSuccess: { [weak self] leadUUID in
                self?.process(leadUUID: leadUUID)
                self?.outputs.didSaveUserAddress.accept(())
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func create(userAddress: UserAddress) {
        guard let dto = userAddress.toDTO() else { return }
        outputs.didStartRequest.accept(())
        authorizedApplyService.authorizedApplyWithAddress(dto: dto)
            .flatMap { [unowned self] leadUUID -> Single<[UserAddress]> in
                self.process(leadUUID: leadUUID)
                return profileService.getAddresses()
            }
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] addresses in
                self?.process(userAddresses: addresses)
                self?.sendClearCartNotification()
                self?.outputs.didSaveUserAddress.accept(())
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func updateUserAddress(with id: Int, brandId: Int) {
        let dto = UpdateAddressDTO(brandId: brandId)
        outputs.didStartRequest.accept(())
        profileService.updateAddress(id: id, dto: dto)
            .flatMap { [unowned self] _ -> Single<String> in
                authorizedApplyService.authorizedApplyOrder()
            }
            .flatMap { [unowned self] leadUUID -> Single<[UserAddress]> in
                self.process(leadUUID: leadUUID)
                return profileService.getAddresses()
            }
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] addresses in
                self?.process(userAddresses: addresses)
                self?.sendClearCartNotification()
                self?.outputs.didSaveUserAddress.accept(())
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func deleteUserAddress(with id: Int) {
        var userAddresses = geoStorage.userAddresses
        userAddresses.removeAll(where: { $0.id == id })
        geoStorage.userAddresses = userAddresses
        outputs.didGetUserAddresses.accept(geoStorage.userAddresses)
        outputs.didStartRequest.accept(())
        profileService.deleteAddress(id: id)
            .flatMap { [unowned self] in
                profileService.getAddresses()
            }
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] userAddresses in
                self?.process(userAddresses: userAddresses)
                self?.outputs.didDeleteUserAddress.accept(())
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(leadUUID: String) {
        defaultStorage.persist(leadUUID: leadUUID)
        NotificationCenter.default.post(name: Constants.InternalNotification.updateMenu.name, object: nil)
    }

    private func sendClearCartNotification() {
        NotificationCenter.default.post(name: Constants.InternalNotification.clearCart.name, object: nil)
    }
}

extension AddressRepositoryImpl {
    enum OrderApplyFlow: Equatable {
        case create(dto: OrderApplyDTO)
        case newAddress(dto: OrderApplyDTO)
        case withCurrentAddress

        static func == (lhs: AddressRepositoryImpl.OrderApplyFlow, rhs: AddressRepositoryImpl.OrderApplyFlow) -> Bool {
            switch (lhs, rhs) {
            case (.create(_), create(_)): return true
            case (.newAddress(_), newAddress(_)): return true
            case (.withCurrentAddress, .withCurrentAddress): return true
            default: return false
            }
        }
    }

    struct Output {
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()

        let didSaveUserAddress = PublishRelay<Void>()
        let didGetUserAddresses = PublishRelay<[UserAddress]>()
        let didDeleteUserAddress = PublishRelay<Void>()
    }
}
