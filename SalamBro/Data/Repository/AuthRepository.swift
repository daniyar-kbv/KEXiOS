//
//  AuthPageRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/4/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AuthRepository: AnyObject {
    var outputs: AuthRepositoryImpl.Output { get }

    func sendOTP(with number: String)
    func verifyOTP(code: String, number: String)
    func resendOTP(with number: String)
    func setUser(name: String)
}

final class AuthRepositoryImpl: AuthRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let authService: AuthService
    private let profileService: ProfileService
    private let ordersService: OrdersService
    private let authorizedApplyService: AuthorizedApplyService
    private let notificationsService: PushNotificationsService
    private let cartStorage: CartStorage
    private let geoStorage: GeoStorage
    private let tokenStorage: AuthTokenStorage
    private let defaultStorage: DefaultStorage

    private var authToken: AccessToken?

    private var userInfo: UserInfoResponse?
    private var leadUUID: String?
    private var cart: Cart?
    private var userAddresses: [UserAddress]?

    init(authService: AuthService,
         profileService: ProfileService,
         ordersService: OrdersService,
         authorizedApplyService: AuthorizedApplyService,
         notificationsService: PushNotificationsService,
         cartStorage: CartStorage,
         geoStorage: GeoStorage,
         tokenStorage: AuthTokenStorage,
         defaultStorage: DefaultStorage)
    {
        self.authService = authService
        self.profileService = profileService
        self.ordersService = ordersService
        self.authorizedApplyService = authorizedApplyService
        self.notificationsService = notificationsService
        self.cartStorage = cartStorage
        self.geoStorage = geoStorage
        self.tokenStorage = tokenStorage
        self.defaultStorage = defaultStorage
    }

    func sendOTP(with number: String) {
        outputs.didStartRequest.accept(())
        authService.authorize(with: SendOTPDTO(phoneNumber: number))
            .subscribe(onSuccess: { [weak self] in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didSendOTP.accept(number)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailAuth.accept(error)
                    return
                }
                self?.outputs.didFailAuth.accept(NetworkError.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)

        outputs.didStartRequest.accept(())
    }

    func setUser(name: String) {
        guard let token = authToken else { return }
        tokenStorage.persist(token: token.access, refreshToken: token.refresh)

        profileService.updateUserInfo(with: UserInfoDTO(name: name, email: nil, mobilePhone: nil))
            .flatMap { _ -> Single<UserInfoResponse> in
                self.profileService.getUserInfo()
            }
            .flatMap { userInfo -> Single<Void> in
                self.userInfo = userInfo
                do {
                    return try self.getFinishAuthSequence()
                } catch {
                    throw error
                }
            }
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] _ in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didRegisteredUser.accept(())
                self?.postUserInfoDependencies()
            }, onError: { [weak self] error in
                self?.tokenStorage.cleanUp()
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailAuthName.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }

    func verifyOTP(code: String, number: String) {
        outputs.didStartRequest.accept(())
        authService.verifyOTP(with: .init(code: code, phoneNumber: number))
            .flatMap { [unowned self] accessToken -> Single<UserInfoResponse> in
                self.authToken = accessToken
                self.tokenStorage.persist(token: accessToken.access, refreshToken: accessToken.refresh)
                return profileService.getUserInfo()
            }
            .flatMap { [unowned self] userInfo -> Single<Void> in
                guard let name = userInfo.name,
                      !name.isEmpty
                else {
                    self.tokenStorage.cleanUp()
                    self.outputs.didGetUnregisteredUser.accept(())
                    self.outputs.didEndRequest.accept(())
                    throw EmptyError()
                }

                self.userInfo = userInfo

                do {
                    return try self.getFinishAuthSequence()
                } catch {
                    throw error
                }
            }
            .subscribe { [weak self] _ in
                self?.outputs.didEndRequest.accept(())
                self?.postUserInfoDependencies()
            } onError: { [weak self] error in
                self?.tokenStorage.cleanUp()
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }

    private func getFinishAuthSequence() throws -> Single<Void> {
        guard let applyDTO = geoStorage.userAddresses.first(where: { $0.isCurrent })?.toDTO(),
              let fcmToken = defaultStorage.fcmToken
        else {
            throw NetworkError.noData
        }

        return authorizedApplyService.authorizedApplyWithAddress(dto: applyDTO)
            .flatMap { [unowned self] leadUUID -> Single<Cart> in
                self.leadUUID = leadUUID
                return ordersService.updateCart(for: leadUUID, dto: cartStorage.cart.toDTO())
            }
            .flatMap { [unowned self] cart -> Single<[UserAddress]> in
                self.cart = cart
                return profileService.getAddresses()
            }
            .flatMap { [unowned self] userAddresses in
                self.userAddresses = userAddresses
                return notificationsService.fcmTokenSave(dto: .init(fcmToken: fcmToken))
            }
    }

    private func postUserInfoDependencies() {
        guard let leadUUID = leadUUID, let cart = cart, let userAddresses = userAddresses else {
            return
        }
        NotificationCenter.default.post(name: Constants.InternalNotification.userInfo.name,
                                        object: userInfo)
        NotificationCenter.default.post(name: Constants.InternalNotification.leadUUID.name,
                                        object: leadUUID)
        NotificationCenter.default.post(name: Constants.InternalNotification.cart.name,
                                        object: cart)
        NotificationCenter.default.post(name: Constants.InternalNotification.userAddresses.name,
                                        object: userAddresses)
    }

    func resendOTP(with number: String) {
        outputs.didStartRequest.accept(())
        authService.resendOTP(with: SendOTPDTO(phoneNumber: number))
            .subscribe(onSuccess: { [weak self] in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didResendOTP.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension AuthRepositoryImpl {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didResendOTP = PublishRelay<Void>()
        let didGetUnregisteredUser = PublishRelay<Void>()
        let didRegisteredUser = PublishRelay<Void>()

        let didFailAuth = PublishRelay<ErrorPresentable>()
        let didFailOTP = PublishRelay<ErrorPresentable>()
        let didFailAuthName = PublishRelay<ErrorPresentable>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
