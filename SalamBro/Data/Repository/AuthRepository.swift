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
    private var numberOfUnregistereduser: String?

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

        bindNotifications()
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

    func verifyOTP(code: String, number: String) {
        outputs.didStartRequest.accept(())
        authService.verifyOTP(with: .init(code: code, phoneNumber: number))
            .flatMap { [unowned self] accessToken -> Single<UserInfoResponse> in
                self.authToken = accessToken
                self.tokenStorage.persist(token: accessToken.access, refreshToken: accessToken.refresh)
                return profileService.getUserInfo()
            }
            .subscribe { [weak self] userInfo in
                self?.checkForAuth(with: userInfo)
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }

    private func checkForAuth(with userInfo: UserInfoResponse) {
        guard let name = userInfo.name, !name.isEmpty else {
            numberOfUnregistereduser = userInfo.mobilePhone
            tokenStorage.cleanUp()
            outputs.didGetUnregisteredUser.accept(())
            return
        }
        NotificationCenter.default.post(name: Constants.InternalNotification.userInfo.name,
                                        object: userInfo)
        applyWithAddress()
    }

    func applyWithAddress() {
        guard let applyDTO = geoStorage.userAddresses.first(where: { $0.isCurrent })?.toDTO(),
              let fcmToken = defaultStorage.fcmToken else { return }

        authorizedApplyService.authorizedApplyWithAddress(dto: applyDTO)
            .flatMap { [unowned self] leadUUID -> Single<Cart> in
                NotificationCenter.default.post(name: Constants.InternalNotification.leadUUID.name,
                                                object: leadUUID)
                return ordersService.updateCart(for: leadUUID, dto: cartStorage.cart.toDTO())
            }
            .flatMap { [unowned self] cart -> Single<[UserAddress]> in
                NotificationCenter.default.post(name: Constants.InternalNotification.cart.name,
                                                object: cart)
                return profileService.getAddresses()
            }
            .flatMap { [unowned self] userAddresses in
                NotificationCenter.default.post(name: Constants.InternalNotification.userAddresses.name,
                                                object: userAddresses)
                return notificationsService.fcmTokenSave(dto: .init(fcmToken: fcmToken))
            }
            .subscribe { [weak self] in
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
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
    private func bindNotifications() {
        NotificationCenter.default.rx
            .notification(Constants.InternalNotification.registerUser.name)
            .subscribe(onNext: { [weak self] name in
                guard let token = self?.authToken, let username = name.object as? String else { return }
                self?.tokenStorage.persist(token: token.access, refreshToken: token.refresh)
                NotificationCenter.default.post(name: Constants.InternalNotification.userInfo.name,
                                                object: UserInfoResponse(name: username, email: nil, mobilePhone: self?.numberOfUnregistereduser, error: nil))
                self?.applyWithAddress()
            })
            .disposed(by: disposeBag)
    }
}

extension AuthRepositoryImpl {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didResendOTP = PublishRelay<Void>()
        let didGetUnregisteredUser = PublishRelay<Void>()

        let didFailAuth = PublishRelay<ErrorPresentable>()
        let didFailOTP = PublishRelay<ErrorPresentable>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
