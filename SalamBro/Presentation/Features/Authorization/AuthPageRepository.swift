//
//  AuthPageRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/4/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AuthPageRepository: AnyObject {
    var outputs: AuthPageRepositoryImpl.Output { get }

    func sendOTP(with number: String)
    func verifyOTP(code: String, number: String)
    func resendOTP(with number: String)
}

final class AuthPageRepositoryImpl: AuthPageRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let authService: AuthService
    private let tokenStorage: AuthTokenStorage

    init(authService: AuthService, tokenStorage: AuthTokenStorage) {
        self.authService = authService
        self.tokenStorage = tokenStorage
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
                self?.handleTokenResponse(accessToken: accessToken)
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

    private func handleTokenResponse(accessToken: AccessToken) {
        outputs.didEndRequest.accept(())
        tokenStorage.persist(token: accessToken.access, refreshToken: accessToken.refresh)
        outputs.didVerifyOTP.accept(())
    }
}

extension AuthPageRepositoryImpl {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didVerifyOTP = PublishRelay<Void>()
        let didResendOTP = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
