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
    func updateUserAddress(with id: Int, brandId: Int)
    func add(userAddress: UserAddress)
    func deleteUserAddress(with id: Int)

    func applyOrder(flow: AddressRepositoryImpl.OrderApplyFlow, completion: (() -> Void)?)
}

final class AddressRepositoryImpl: AddressRepository {
    private(set) var outputs: Output = .init()

    private let geoStorage: GeoStorage
    private let brandStorage: BrandStorage
    private let defaultStorage: DefaultStorage
    private let authTokenStorage: AuthTokenStorage

    private let ordersService: OrdersService
    private let profileService: ProfileService
    private let notificationsService: PushNotificationsService

    private let disposeBag = DisposeBag()

    init(storage: GeoStorage,
         brandStorage: BrandStorage,
         ordersService: OrdersService,
         profileService: ProfileService,
         notificationsService: PushNotificationsService,
         defaultStorage: DefaultStorage,
         authTokenStorage: AuthTokenStorage)
    {
        geoStorage = storage
        self.brandStorage = brandStorage
        self.ordersService = ordersService
        self.profileService = profileService
        self.notificationsService = notificationsService
        self.defaultStorage = defaultStorage
        self.authTokenStorage = authTokenStorage
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
            .subscribe(onSuccess: { [weak self] addresses in
                self?.process(userAddresses: addresses)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    private func process(userAddresses: [UserAddress]) {
        let oldCurrent = getCurrentUserAddress()
        geoStorage.userAddresses = userAddresses
        outputs.didGetUserAddresses.accept(userAddresses)
        if oldCurrent != getCurrentUserAddress() {
            outputs.needsUpdate.accept(())
        } else {
            outputs.didEndRequest.accept(())
        }
    }

    func getCurrentUserAddress() -> UserAddress? {
        return geoStorage.userAddresses.first(where: { $0.isCurrent })
    }

    func updateUserAddress(with id: Int, brandId: Int) {
        let dto = UpdateAddressDTO(brandId: brandId)
        profileService.updateAddress(id: id, dto: dto)
            .subscribe(onSuccess: { [weak self] in
                self?.applyOrder(flow: .withCurrentAddress)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }

    func add(userAddress: UserAddress) {
        guard let dto = userAddress.toDTO() else { return }
        applyOrder(flow: .newAddress(dto: dto))
    }

    func deleteUserAddress(with id: Int) {
        var userAddresses = geoStorage.userAddresses
        userAddresses.removeAll(where: { $0.id == id })
        geoStorage.userAddresses = userAddresses
        outputs.didGetUserAddresses.accept(geoStorage.userAddresses)
        outputs.didStartRequest.accept(())
        profileService.deleteAddress(id: id)
            .subscribe(onSuccess: { [weak self] in
                self?.outputs.didDeleteUserAddress.accept(())
                self?.getUserAddresses()
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            })
            .disposed(by: disposeBag)
    }
}

extension AddressRepositoryImpl {
    func applyOrder(flow: OrderApplyFlow, completion: (() -> Void)? = nil) {
        guard let request = getRequest(for: flow) else { return }

        outputs.didStartRequest.accept(())
        request.subscribe { [weak self] leadUUID in
            self?.process(leadUUID: leadUUID, flow: flow)
            self?.getUserAddresses()
            completion?()
        } onError: { [weak self] error in
            self?.outputs.didEndRequest.accept(())
            guard let error = error as? ErrorPresentable else { return }
            self?.outputs.didFail.accept(error)
        }.disposed(by: disposeBag)
    }

    private func getRequest(for flow: OrderApplyFlow) -> Single<String>? {
        switch flow {
        case let .create(dto): return ordersService.applyOrder(dto: dto)
        case let .newAddress(dto): return ordersService.authorizedApplyWithAddress(dto: dto)
        case .withCurrentAddress: return ordersService.authorizedApplyOrder()
        }
    }

    private func process(leadUUID: String, flow: OrderApplyFlow) {
        defaultStorage.persist(leadUUID: leadUUID)
        outputs.didGetLeadUUID.accept(())
        outputs.needsClearCart.accept(flow != .withCurrentAddress)
        fcmTokenCreate()
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

        let didGetLeadUUID = PublishRelay<Void>()
        let didGetUserAddresses = PublishRelay<[UserAddress]>()
        let needsUpdate = PublishRelay<Void>()
        let didDeleteUserAddress = PublishRelay<Void>()

        let needsClearCart = PublishRelay<Bool>()
    }
}
