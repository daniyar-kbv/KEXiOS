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
    private let locationRepository: AddressRepository
    private let authService: AuthService
    private var phoneNumber: String = ""

    init(locationRepository: AddressRepository, authService: AuthService) {
        self.locationRepository = locationRepository
        self.authService = authService
    }

    private func handleResponse(error: Error?) {
        outputs.didEndRequest.accept(())

        if let error = error as? ErrorPresentable {
            outputs.didFail.accept(error)
            return
        }

        outputs.didSendOTP.accept(phoneNumber)
    }
}

extension AuthorizationViewModelImpl: AuthorizationViewModel {
    func setPhoneNumber(_ value: String) {
        phoneNumber = getCountryCode() + value
    }

    func sendOTP() {
        outputs.didStartRequest.accept(())
        authService.authorize(with: SendOTPDTO(phoneNumber: phoneNumber))
            .subscribe(onSuccess: { [weak self] in
                self?.handleResponse(error: nil)
            }, onError: { [weak self] error in
                self?.handleResponse(error: error)
            })
            .disposed(by: disposeBag)
    }

    func getCountryCode() -> String {
        guard let country = locationRepository.getCurrentCountry() else {
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
