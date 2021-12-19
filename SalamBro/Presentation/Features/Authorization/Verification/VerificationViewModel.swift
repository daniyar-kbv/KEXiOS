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
    private let addressRepository: AddressRepository
    private(set) var phoneNumber: String

    init(authRepository: AuthRepository,
         addressRepository: AddressRepository,
         phoneNumber: String)
    {
        self.authRepository = authRepository
        self.addressRepository = addressRepository
        self.phoneNumber = phoneNumber

        bindOutputs()
    }

    private func bindOutputs() {
        authRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didResendOTP
            .bind(to: outputs.didResendOTP)
            .disposed(by: disposeBag)

        authRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didFailOTP
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)

        authRepository.outputs.didGetUnregisteredUser
            .subscribe(onNext: { [weak self] in
                self?.outputs.didFinish.accept(false)
            })
            .disposed(by: disposeBag)

        authRepository.outputs.didFinish
            .subscribe(onNext: { [weak self] isFinished in
                self?.outputs.didFinish.accept(isFinished)
            })
            .disposed(by: disposeBag)

        authRepository.outputs.didFailBranch
            .bind(to: outputs.didFailBranch)
            .disposed(by: disposeBag)

        authRepository.outputs.didResendOTP
            .bind(to: outputs.didResendOTP)
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
        let didFinish = PublishRelay<Bool>()
        let didResendOTP = PublishRelay<Void>()
        let didFailBranch = PublishRelay<ErrorPresentable>()
    }
}
