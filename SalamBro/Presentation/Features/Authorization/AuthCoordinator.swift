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
    var didAuthorize: (() -> Void)?

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
            .subscribe(onNext: { [weak self] url, name in
                self?.showAgreementPage(url: url, name: name)
            })
            .disposed(by: disposeBag)

        authPage.hidesBottomBarWhenPushed = true
        router.push(viewController: authPage, animated: true)
    }

    private func showOTPConfirmationPage(phoneNumber: String) {
        let verificationPage = pagesFactory.makeVerificationPage(phoneNumber: phoneNumber)

        verificationPage.outputs.didFinish
            .subscribe(onNext: { [weak self] hasEnteredName in
                guard hasEnteredName else {
                    self?.showNameEnteringPage()
                    return
                }
                self?.handleAuthTermination()
                self?.didAuthorize?()
            })
            .disposed(by: disposeBag)

        router.push(viewController: verificationPage, animated: true)
    }

    private func showNameEnteringPage() {
        let nameEnteringPage = pagesFactory.makeNameEnteringPage()

        nameEnteringPage.didGetEnteredName = { [weak self] in
            self?.handleAuthTermination()
            self?.didAuthorize?()
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

        let navController = SBNavigationController(rootViewController: countryCodePickerPage)
        router.present(navController, animated: true, completion: nil)
    }

    private func showAgreementPage(url: URL, name: String) {
        let agreementPage = pagesFactory.makeAgreementPage(url: url, name: name)

        router.push(viewController: agreementPage, animated: true)
    }
}

extension AuthCoordinator {
    private func handleAuthTermination() {
        router.popToRootViewController(animated: true)
        didFinish?()
    }
}
