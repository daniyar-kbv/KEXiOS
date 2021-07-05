//
//  AuthorizationViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AuthorizationViewModel: AnyObject {
    func setPhoneNumber(_ value: String)
    func sendOTP()
    func getCountryCode() -> String

    var outputs: AuthorizationViewModelImpl.Output { get }
}

final class AuthorizationViewModelImpl {
    private(set) var outputs = Output()
    private let disposeBag = DisposeBag()

    private let addressRepository: AddressRepository
    private let authRepository: AuthPageRepository
    private var phoneNumber: String = ""

    init(addressRepository: AddressRepository, authRepository: AuthPageRepository) {
        self.addressRepository = addressRepository
        self.authRepository = authRepository
        bindOutputs()
    }

    private func bindOutputs() {
        authRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didSendOTP
            .bind { [weak self] number in
                self?.outputs.didSendOTP.accept(number)
            }
            .disposed(by: disposeBag)

        authRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        authRepository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }
}

extension AuthorizationViewModelImpl: AuthorizationViewModel {
    func setPhoneNumber(_ value: String) {
        phoneNumber = getCountryCode() + value
    }

    func sendOTP() {
        authRepository.sendOTP(with: phoneNumber)
    }

    func getCountryCode() -> String {
        guard let country = addressRepository.getCurrentCountry() else {
            return "+7" // by default Kazakhstan
        }

        return country.countryCode
    }
}

extension AuthorizationViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didSendOTP = PublishRelay<String>()
    }
}
