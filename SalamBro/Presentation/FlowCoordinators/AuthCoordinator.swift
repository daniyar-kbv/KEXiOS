//
//  AuthCoordinator.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class AuthCoordinator {
    private let disposeBag = DisposeBag()

    var didFinish: (() -> Void)?

    private var navigationController: UINavigationController?
    private let pagesFactory: AuthPagesFactory

    init(navigationController: UINavigationController?, pagesFactory: AuthPagesFactory) {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory
    }

    func startAuthFlow() {
        let authPage = pagesFactory.makeAuthorizationPage()

        authPage.outputs.didSendOTP
            .subscribe(onNext: { [weak self] phoneNumber in
                self?.showOTPConfirmationPage(phoneNumber: phoneNumber)
            })
            .disposed(by: disposeBag)

        navigationController?.pushViewController(authPage, animated: true)
    }

    private func showOTPConfirmationPage(phoneNumber: String) {
        let verificationPage = pagesFactory.makeVerificationPage(phoneNumber: phoneNumber)

        verificationPage.outputs.didGetToken
            .subscribe(onNext: { [weak self] token in
                debugPrint(token)
                self?.showNameEnteringPage()
            })
            .disposed(by: disposeBag)

        navigationController?.pushViewController(verificationPage, animated: true)
    }

    private func showNameEnteringPage() {
        let nameEnteringPage = pagesFactory.makeNameEnteringPage()

        nameEnteringPage.didGetEnteredName = { [weak self] enteredName in
            debugPrint(enteredName)
            self?.navigationController?.popToRootViewController(animated: true)
            self?.didFinish?()
        }

        navigationController?.pushViewController(nameEnteringPage, animated: true)
    }
}
