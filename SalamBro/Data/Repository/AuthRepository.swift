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

    func verifyOTP(code: String, number: String) {
        outputs.didStartRequest.accept(())
        authService.verifyOTP(with: .init(code: code, phoneNumber: number))
            .retryWhenUnautharized()
            .subscribe { [weak self] accessToken in
                self?.tokenStorage.persist(token: accessToken.access, refreshToken: accessToken.refresh)
                self?.registerUser()
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }

    func registerUser() {
        profileService.getUserInfo()
            .subscribe { [weak self] info in
                self?.applyWithAddress()
                guard let _ = info.name else {
                    self?.outputs.didGetUnregisteredUser.accept(())
                    return
                }
                NotificationCenter.default.post(name: Constants.InternalNotification.userInfo.name,
                                                object: info)
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }

    func applyWithAddress() {
        guard let applyDTO = geoStorage.userAddresses.first(where: { $0.isCurrent })?.toDTO() else { return }

        authorizedApplyService.authorizedApplyWithAddress(dto: applyDTO)
            .subscribe { [weak self] leadUUID in
                NotificationCenter.default.post(name: Constants.InternalNotification.leadUUID.name,
                                                object: leadUUID)
                self?.updateCart(with: leadUUID)
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }

    func updateCart(with leadUUID: String) {
        ordersService.updateCart(for: leadUUID, dto: cartStorage.cart.toDTO())
            .subscribe { [weak self] cart in
                NotificationCenter.default.post(name: Constants.InternalNotification.cart.name,
                                                object: cart)
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFailOTP.accept(error)
                }
            }
            .disposed(by: disposeBag)
    }

    func getAddresses() {
        guard let fcmToken = defaultStorage.fcmToken else { return }

        profileService.getAddresses()
            .subscribe { [weak self] addresses in
                NotificationCenter.default.post(name: Constants.InternalNotification.userAddresses.name,
                                                object: addresses)
                self?.notificationsService.fcmTokenSave(dto: .init(fcmToken: fcmToken))
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

        let didFailAuth = PublishRelay<ErrorPresentable>()
        let didFailOTP = PublishRelay<ErrorPresentable>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
