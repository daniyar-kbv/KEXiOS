//
//  VerificationViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

final class VerificationViewModel {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private let service: AuthService
    private(set) var phoneNumber: String

    init(service: AuthService, phoneNumber: String) {
        self.service = service
        self.phoneNumber = phoneNumber
    }

    func verifyOTP(code: String) {
        outputs.didStartRequest.accept(())
        service.verifyOTP(with: OTPVerifyDTO(code: code, phoneNumber: phoneNumber))
            .subscribe { [weak self] accessToken in
                self?.handleTokenResponse(accessToken: accessToken)
            } onError: { [weak self] error in
                self?.handleErrorResponse(error: error)
            }
            .disposed(by: disposeBag)
    }

    func resendOTP() {
        outputs.didStartRequest.accept(())
        service.resendOTP(with: SendOTPDTO(phoneNumber: phoneNumber))
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
        outputs.didVerifyOTP.accept(accessToken)
    }
}

extension VerificationViewModel {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didVerifyOTP = PublishRelay<AccessToken>()
        let didResendOTP = PublishRelay<Void>()
    }
}
