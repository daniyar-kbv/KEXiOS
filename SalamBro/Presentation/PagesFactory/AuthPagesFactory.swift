//
//  AuthPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import Foundation

final class AuthPagesFactory: DependencyFactory {
    func makeAuthorizationPage() -> AuthorizationController {
        return scoped(.init(viewModel: makeAuthPageViewModel()))
    }

    private func makeAuthPageViewModel() -> AuthorizationViewModel {
        return scoped(.init(locationRepository: DIResolver.resolve(LocationRepository.self)!,
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
}

extension AuthPagesFactory {
    private func getAuthService() -> AuthService {
        return DIResolver.resolve(AuthService.self)!
    }
}
