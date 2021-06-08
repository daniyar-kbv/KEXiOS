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
    func makeAuthorizationPage() -> AuthorizationController {
        return scoped(.init(viewModel: makeAuthPageViewModel()))
    }

    private func makeAuthPageViewModel() -> AuthorizationViewModel {
        return scoped(AuthorizationViewModelImpl(locationRepository: DIResolver.resolve(LocationRepository.self)!,
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
        return scoped(CountryCodePickerViewModelImpl(repository: getLocationRepository(),
                                                     service: getLocationService()))
    }

    func makeAgreementPage() -> AgreementController {
        return scoped(.init(nibName: nil, bundle: nil))
    }
}

// MARK: Tech debt, удалить, нужно чтобы сетилось через init, serviceComponents.

extension AuthPagesFactoryImpl {
    private func getAuthService() -> AuthService {
        return DIResolver.resolve(AuthService.self)!
    }

    private func getGeoRepository() -> GeoRepository {
        return DIResolver.resolve(GeoRepository.self)!
    }

    private func getLocationService() -> LocationService {
        return DIResolver.resolve(LocationService.self)!
    }

    private func getLocationRepository() -> LocationRepository {
        return DIResolver.resolve(LocationRepository.self)!
    }
}
