//
//  AuthCoordinator.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class AuthCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    var didFinish: (() -> Void)?

    private let router: Router
    private let pagesFactory: AuthPagesFactory

    init(router: Router, pagesFactory: AuthPagesFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let authPage = pagesFactory.makeAuthorizationPage()

        authPage.outputs.didSendOTP
            .subscribe(onNext: { [weak self] phoneNumber in
                self?.showOTPConfirmationPage(phoneNumber: phoneNumber)
            })
            .disposed(by: disposeBag)

        authPage.outputs.didCloseAuthFlow
            .subscribe(onNext: { [weak self] in
                self?.handleAuthTermination()
            })
            .disposed(by: disposeBag)

        authPage.outputs.handleChangeCountryCode
            .subscribe(onNext: { [weak self, weak authPage] in
                self?.showCountryCodePicker(onSelectCountry: { selectedCountry in
                    authPage?.changeCountryCode(title: selectedCountry.countryCode)
                })
            })
            .disposed(by: disposeBag)

        authPage.outputs.handleAgreementTextAction
            .subscribe(onNext: { [weak self] in
                self?.showAgreementPage()
            })
            .disposed(by: disposeBag)

        authPage.hidesBottomBarWhenPushed = true
        router.push(viewController: authPage, animated: true)
    }

    private func showOTPConfirmationPage(phoneNumber: String) {
        let verificationPage = pagesFactory.makeVerificationPage(phoneNumber: phoneNumber)

        verificationPage.outputs.didGetToken
            .subscribe(onNext: { [weak self] in
                if let _ = DefaultStorageImpl.sharedStorage.userName {
                    self?.handleAuthTermination()
                    return
                }

                self?.showNameEnteringPage()
            })
            .disposed(by: disposeBag)

        router.push(viewController: verificationPage, animated: true)
    }

    private func showNameEnteringPage() {
        let nameEnteringPage = pagesFactory.makeNameEnteringPage()

        nameEnteringPage.didGetEnteredName = { [weak self] _ in
            self?.handleAuthTermination()
        }

        router.push(viewController: nameEnteringPage, animated: true)
    }

    private func showCountryCodePicker(onSelectCountry: @escaping ((Country) -> Void)) {
        let countryCodePickerPage = pagesFactory.makeCountryCodePickerPage()

        countryCodePickerPage.outputs.didSelectCountryCode
            .subscribe(onNext: { [weak self] country in
                onSelectCountry(country)
                self?.router.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        countryCodePickerPage.outputs.close
            .subscribe(onNext: {
                countryCodePickerPage.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let navController = UINavigationController(rootViewController: countryCodePickerPage)
        router.present(navController, animated: true, completion: nil)
    }

    private func showAgreementPage() {
        let agreementPage = pagesFactory.makeAgreementPage()

        router.push(viewController: agreementPage, animated: true)
    }
}

extension AuthCoordinator {
    private func handleAuthTermination() {
        router.popToRootViewController(animated: true)
        didFinish?()
    }
}
