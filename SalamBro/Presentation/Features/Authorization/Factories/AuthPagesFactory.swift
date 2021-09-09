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
    func makeAgreementPage(url: URL, name: String) -> AgreementController
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
        return scoped(AuthorizationViewModelImpl(addressRepository: repositoryComponents.makeAddressRepository(),
                                                 documentsRepository: repositoryComponents.makeDocumentsRepository(),
                                                 authRepository: repositoryComponents.makeAuthRepository()))
    }

    func makeVerificationPage(phoneNumber: String) -> VerificationController {
        return scoped(.init(viewModel: makeVerificationViewModel(phoneNumber: phoneNumber)))
    }

    private func makeVerificationViewModel(phoneNumber: String) -> VerificationViewModel {
        return scoped(.init(authRepository: repositoryComponents.makeAuthRepository(),
                            addressRepository: repositoryComponents.makeAddressRepository(),
                            profileRepository: repositoryComponents.makeProfileRepository(),
                            phoneNumber: phoneNumber))
    }

    func makeNameEnteringPage() -> SetNameController {
        return scoped(.init(viewModel: makeSetNameViewModel()))
    }

    private func makeSetNameViewModel() -> SetNameViewModel {
        return scoped(SetNameViewModelImpl(repository: repositoryComponents.makeAuthRepository()))
    }

    func makeCountryCodePickerPage() -> CountryCodePickerViewController {
        return scoped(.init(viewModel: makeCountryCodePickerViewModel()))
    }

    private func makeCountryCodePickerViewModel() -> CountryCodePickerViewModel {
        return scoped(CountryCodePickerViewModelImpl(countriesRepository: repositoryComponents.makeCountriesRepository(), addressRepository: repositoryComponents.makeAddressRepository()))
    }

    func makeAgreementPage(url: URL, name: String) -> AgreementController {
        return scoped(.init(viewModel: makeAgreementViewModel(url: url, name: name)))
    }

    private func makeAgreementViewModel(url: URL, name: String) -> AgreementViewModel {
        return scoped(AgreementViewModelImpl(input: .init(url: url, name: name)))
    }
}
