//
//  AuthCoordinator.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let disposeBag = DisposeBag()
    private let pagesFactory: AuthPagesFactory

    init(navigationController: UINavigationController, pagesFactory: AuthPagesFactory) {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory

        self.pagesFactory.coordinator = self
    }

    func start() {
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

        navigationController.pushViewController(authPage, animated: true)
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

        navigationController.pushViewController(verificationPage, animated: true)
    }

    private func showNameEnteringPage() {
        let nameEnteringPage = pagesFactory.makeNameEnteringPage()

        nameEnteringPage.didGetEnteredName = { [weak self] _ in
            self?.handleAuthTermination()
        }

        navigationController.pushViewController(nameEnteringPage, animated: true)
    }

    func showCountryCodePicker(onSelectCountry: @escaping ((Country) -> Void)) {
        let countryCodePickerPage = pagesFactory.makeCountryCodePickerPage()

        countryCodePickerPage.outputs.didSelectCountryCode
            .subscribe(onNext: { [weak self] country in
                onSelectCountry(country)
                self?.navigationController.presentingViewController?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        let nav = UINavigationController(rootViewController: countryCodePickerPage)
        navigationController.present(nav, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}

extension AuthCoordinator {
    private func handleAuthTermination() {
        navigationController.popToRootViewController(animated: true)
        didFinish()
    }
}
