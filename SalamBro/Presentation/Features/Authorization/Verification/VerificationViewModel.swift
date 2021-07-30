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

    private let authRepository: AuthRepository
    private let notificationsRepository: PushNotificationsRepository
    private(set) var phoneNumber: String

    init(authRepository: AuthRepository,
         notificationsRepository: PushNotificationsRepository,
         phoneNumber: String)
    {
        self.authRepository = authRepository
        self.notificationsRepository = notificationsRepository
        self.phoneNumber = phoneNumber
        bindOutputs()
    }

    private func bindOutputs() {
        authRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didVerifyOTP
            .bind(to: outputs.didVerifyOTP)
            .disposed(by: disposeBag)

        authRepository.outputs.didResendOTP
            .bind(to: outputs.didResendOTP)
            .disposed(by: disposeBag)

        authRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }

    func verifyOTP(code: String) {
        authRepository.verifyOTP(code: code, number: phoneNumber)
    }

    func resendOTP() {
        authRepository.resendOTP(with: phoneNumber)
    }
}

extension VerificationViewModel {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didVerifyOTP = PublishRelay<Void>()
        let didResendOTP = PublishRelay<Void>()
    }
}
