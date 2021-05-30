//
//  AuthorizationViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

final class AuthorizationViewModel {
    let outputs = Output()
    private let disposeBag = DisposeBag()
    private let locationRepository: LocationRepository
    private let authService: AuthService
    private var phoneNumber: String = ""

    init(locationRepository: LocationRepository, authService: AuthService) {
        self.locationRepository = locationRepository
        self.authService = authService
    }

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

    private func handleResponse(error: Error?) {
        outputs.didEndRequest.accept(())

        if let error = error as? ErrorPresentable {
            outputs.didFail.accept(error)
            return
        }

        outputs.didSendOTP.accept(phoneNumber)
    }

    func getCountryCode() -> String {
        guard let country = locationRepository.getCurrentCountry() else {
            return "+7" // by default Kazakhstan
        }

        return country.countryCode
    }
}

extension AuthorizationViewModel {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didSendOTP = PublishRelay<String>()
    }
}
