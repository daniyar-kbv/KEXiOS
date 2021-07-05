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

    func getDocuments()
    func getUserAgreementInfo() -> (URL, String)?

    var outputs: AuthorizationViewModelImpl.Output { get }
}

final class AuthorizationViewModelImpl {
    private(set) var outputs = Output()
    private let disposeBag = DisposeBag()
    private let locationRepository: AddressRepository
    private let documentsRepository: DocumentsRepository
    private let authService: AuthService
    private var phoneNumber: String = ""
    private var userAgreement: Document?

    init(locationRepository: AddressRepository,
         documentsRepository: DocumentsRepository,
         authService: AuthService)
    {
        self.locationRepository = locationRepository
        self.documentsRepository = documentsRepository
        self.authService = authService

        bindDocumentsRepository()
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

    func getDocuments() {
        documentsRepository.getUserAgreement()
    }

    func getUserAgreementInfo() -> (URL, String)? {
        guard let userAgreement = userAgreement,
              let url = URL(string: userAgreement.link) else { return nil }
        return (url, userAgreement.name)
    }
}

extension AuthorizationViewModelImpl {
    private func bindDocumentsRepository() {
        documentsRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        documentsRepository.outputs.didStartRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        documentsRepository.outputs.didGetError
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)

        documentsRepository.outputs.didGetUserAgreement
            .subscribe(onNext: { [weak self] userAgreement in
                self?.userAgreement = userAgreement
            }).disposed(by: disposeBag)
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
