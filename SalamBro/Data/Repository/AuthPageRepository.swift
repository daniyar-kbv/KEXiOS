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
    func refreshToken()
}

final class AuthRepositoryImpl: AuthRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let authService: AuthService
    private let notificationsService: PushNotificationsService
    private let tokenStorage: AuthTokenStorage
    private let defaultStorage: DefaultStorage

    init(authService: AuthService,
         notificationsService: PushNotificationsService,
         tokenStorage: AuthTokenStorage,
         defaultStorage: DefaultStorage)
    {
        self.authService = authService
        self.notificationsService = notificationsService
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
        outputs.didStartRequest.accept(())
        authService.verifyOTP(with: OTPVerifyDTO(code: code, phoneNumber: number))
            .subscribe { [weak self] accessToken in
                self?.handleTokenResponse(accessToken: accessToken.access, refreshToken: accessToken.refresh)
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

    func refreshToken() {
        guard let refreshToken = tokenStorage.refreshToken else { return }
        authService.refreshToken(with: .init(refresh: refreshToken))
            .subscribe(onSuccess: { [weak self] refreshTokenResponse in
                self?.handleTokenResponse(accessToken: refreshTokenResponse.access, refreshToken: refreshTokenResponse.refresh)
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

    private func handleTokenResponse(accessToken: String, refreshToken: String) {
        outputs.didEndRequest.accept(())
        tokenStorage.persist(token: accessToken, refreshToken: refreshToken)
        outputs.didVerifyOTP.accept(())
    }
}

extension AuthRepositoryImpl {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didVerifyOTP = PublishRelay<Void>()
        let didResendOTP = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
