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
    private let notificationsRepository: PushNotificationsRepository
    private let profileRepository: ProfileRepository
    private(set) var phoneNumber: String

    init(authRepository: AuthRepository,
         addressRepository: AddressRepository,
         notificationsRepository: PushNotificationsRepository,
         profileRepository: ProfileRepository,
         phoneNumber: String)
    {
        self.authRepository = authRepository
        self.addressRepository = addressRepository
        self.notificationsRepository = notificationsRepository
        self.profileRepository = profileRepository
        self.phoneNumber = phoneNumber

        bindOutputs()
        bindProfileRepository()
    }

    private func bindOutputs() {
        authRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didVerifyOTP
            .subscribe(onNext: { [weak self] in
                self?.addressRepository.applyOrder(userAddress: self?.addressRepository.getCurrentUserAddress()) {
                    self?.profileRepository.fetchUserInfo()
                }
            })
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

    private func bindProfileRepository() {
        profileRepository.outputs.didGetUserInfo
            .subscribe(onNext: { [weak self] userInfo in
                self?.outputs.didFinish.accept(userInfo.name != nil)
            })
            .disposed(by: disposeBag)

        profileRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        profileRepository.outputs.didFail
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
        let didFinish = PublishRelay<Bool>()
        let didResendOTP = PublishRelay<Void>()
    }
}
