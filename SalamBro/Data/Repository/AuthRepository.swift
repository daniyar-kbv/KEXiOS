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
                    self?.outputs.didFail.accept(error)
                    return
                }
                self?.outputs.didFail.accept(NetworkError.error(error.localizedDescription))
            })
            .disposed(by: disposeBag)

        outputs.didStartRequest.accept(())
    }

    func verifyOTP(code: String, number: String) {
        guard let applyDTO = geoStorage.userAddresses.first(where: { $0.isCurrent })?.toDTO(),
              let fcmToken = defaultStorage.fcmToken else { return }

        outputs.didStartRequest.accept(())
        authService.verifyOTP(with: .init(code: code, phoneNumber: number))
            .flatMap { [unowned self] accessToken -> Single<UserInfoResponse> in
                self.tokenStorage.persist(token: accessToken.access, refreshToken: accessToken.refresh)
                return profileService.getUserInfo()
            }
            .flatMap { [unowned self] userInfo -> Single<String> in
                NotificationCenter.default.post(name: Constants.InternalNotification.userInfo.name,
                                                object: userInfo)
                return authorizedApplyService.authorizedApplyWithAddress(dto: applyDTO)
            }
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
            .retryWhenUnautharized()
            .subscribe { [weak self] in
                self?.outputs.didEndRequest.accept(())
            } onError: { [weak self] error in
                self?.handleErrorResponse(error: error)
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
                self?.handleErrorResponse(error: error)
            })
            .disposed(by: disposeBag)
    }

    private func handleErrorResponse(error: Error?) {
        outputs.didEndRequest.accept(())
        if let error = error as? ErrorPresentable {
            outputs.didFail.accept(error)
            return
        }
    }
}

extension AuthRepositoryImpl {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didResendOTP = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
