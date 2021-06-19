//
//  AuthPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import Foundation

protocol AuthPagesFactory: AnyObject {
    func makeAuthorizationPage() -> AuthorizationController
    func makeVerificationPage(phoneNumber: String) -> VerificationController
    func makeNameEnteringPage() -> SetNameController
    func makeCountryCodePickerPage() -> CountryCodePickerViewController
    func makeAgreementPage() -> AgreementController
}

final class AuthPagesFactoryImpl: DependencyFactory, AuthPagesFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeAuthorizationPage() -> AuthorizationController {
        return scoped(.init(viewModel: makeAuthPageViewModel()))
    }

    private func makeAuthPageViewModel() -> AuthorizationViewModel {
        return scoped(AuthorizationViewModelImpl(locationRepository: repositoryComponents.makeLocationRepository(),
                                                 authService: serviceComponents.authService()))
    }

    func makeVerificationPage(phoneNumber: String) -> VerificationController {
        return scoped(.init(viewModel: makeVerificationViewModel(phoneNumber: phoneNumber)))
    }

    private func makeVerificationViewModel(phoneNumber: String) -> VerificationViewModel {
        return scoped(.init(service: serviceComponents.authService(),
                            tokenStorage: AuthTokenStorageImpl.sharedStorage,
                            phoneNumber: phoneNumber))
    }

    func makeNameEnteringPage() -> SetNameController {
        return scoped(.init(viewModel: makeSetNameViewModel()))
    }

    private func makeSetNameViewModel() -> SetNameViewModel {
        return scoped(SetNameViewModelImpl(defaultStorage: DefaultStorageImpl.sharedStorage, profileService: serviceComponents.profileService()))
    }

    func makeCountryCodePickerPage() -> CountryCodePickerViewController {
        return scoped(.init(viewModel: makeCountryCodePickerViewModel()))
    }

    private func makeCountryCodePickerViewModel() -> CountryCodePickerViewModel {
        return scoped(CountryCodePickerViewModelImpl(repository: repositoryComponents.makeLocationRepository(),
                                                     service: serviceComponents.locationService()))
    }

    func makeAgreementPage() -> AgreementController {
        return scoped(.init(viewModel: makeAgreementViewModel()))
    }

    private func makeAgreementViewModel() -> AgreementViewModel {
        return scoped(AgreementViewModelImpl())
    }
}
