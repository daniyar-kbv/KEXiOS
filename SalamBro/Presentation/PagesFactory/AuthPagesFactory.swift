//
//  AuthPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import Foundation

protocol AuthPagesFactory: AnyObject {
    var coordinator: AuthCoordinator! { get set }

    func makeAuthorizationPage() -> AuthorizationController
    func makeVerificationPage(phoneNumber: String) -> VerificationController
    func makeNameEnteringPage() -> SetNameController
    func makeCountryCodePickerPage() -> CountryCodePickerViewController
}

final class AuthPagesFactoryImpl: DependencyFactory, AuthPagesFactory {
    weak var coordinator: AuthCoordinator!

    func makeAuthorizationPage() -> AuthorizationController {
        return scoped(.init(viewModel: makeAuthPageViewModel()))
    }

    private func makeAuthPageViewModel() -> AuthorizationViewModel {
        return scoped(.init(coordinator: coordinator,
                            locationRepository: DIResolver.resolve(LocationRepository.self)!,
                            authService: getAuthService()))
    }

    func makeVerificationPage(phoneNumber: String) -> VerificationController {
        return scoped(.init(viewModel: makeVerificationViewModel(phoneNumber: phoneNumber)))
    }

    private func makeVerificationViewModel(phoneNumber: String) -> VerificationViewModel {
        return scoped(.init(service: getAuthService(),
                            tokenStorage: AuthTokenStorageImpl.sharedStorage,
                            phoneNumber: phoneNumber))
    }

    func makeNameEnteringPage() -> SetNameController {
        return scoped(.init(viewModel: makeSetNameViewModel()))
    }

    private func makeSetNameViewModel() -> SetNameViewModel {
        return scoped(.init(defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    func makeCountryCodePickerPage() -> CountryCodePickerViewController {
        return scoped(.init(viewModel: makeCountryCodePickerViewModel()))
    }

    private func makeCountryCodePickerViewModel() -> CountryCodePickerViewModel {
        return scoped(.init(repository: getGeoRepository()))
    }
}

extension AuthPagesFactoryImpl {
    private func getAuthService() -> AuthService {
        return DIResolver.resolve(AuthService.self)!
    }

    private func getGeoRepository() -> GeoRepository {
        return DIResolver.resolve(GeoRepository.self)!
    }
}
