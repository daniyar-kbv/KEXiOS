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

    private let repository: AuthRepository
    private(set) var phoneNumber: String

    init(repository: AuthRepository, phoneNumber: String) {
        self.repository = repository
        self.phoneNumber = phoneNumber
        bindOutputs()
    }

    private func bindOutputs() {
        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didVerifyOTP
            .bind(to: outputs.didVerifyOTP)
            .disposed(by: disposeBag)

        repository.outputs.didResendOTP
            .bind(to: outputs.didResendOTP)
            .disposed(by: disposeBag)

        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }

    func verifyOTP(code: String) {
        repository.verifyOTP(code: code, number: phoneNumber)
    }

    func resendOTP() {
        repository.resendOTP(with: phoneNumber)
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
