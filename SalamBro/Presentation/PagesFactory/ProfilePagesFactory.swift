//
//  ProfilePagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 12.06.2021.
//

import Foundation

protocol ProfilePagesFactory: AnyObject {
    func makeProfilePage() -> ProfilePage
    func makeChangeUserInfoPage(userInfo: UserInfoResponse) -> ChangeNameController
    func makeChangeLanguagePage() -> ChangeLanguageController // FIXME: Нужно переписать этот class
}

final class ProfilePagesFactoryImpl: DependencyFactory, ProfilePagesFactory {
    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }

    func makeProfilePage() -> ProfilePage {
        return scoped(.init(viewModel: makeProfileViewModel()))
    }

    private func makeProfileViewModel() -> ProfileViewModel {
        return scoped(ProfileViewModelImpl(repository: makeProfilePageRepository()))
    }

    private func makeProfilePageRepository() -> ProfilePageRepository {
        return scoped(ProfilePageRepositoryImpl(profileService: serviceComponents.profileService(),
                                                authService: serviceComponents.authService(),
                                                tokenStorage: AuthTokenStorageImpl.sharedStorage))
    }

    func makeChangeUserInfoPage(userInfo: UserInfoResponse) -> ChangeNameController {
        return scoped(.init(viewModel: makeChangeUserInfoViewModel(userInfo: userInfo)))
    }

    private func makeChangeUserInfoViewModel(userInfo: UserInfoResponse) -> ChangeNameViewModel {
        return scoped(ChangeNameViewModelImpl(service: serviceComponents.profileService(), userInfo: userInfo, defaultStorage: DefaultStorageImpl.sharedStorage))
    }

    /// Нужно переписать  используя viewModel, snapkit и rxswift
    func makeChangeLanguagePage() -> ChangeLanguageController {
        return scoped(.init(viewModel: makeChangeLanguageViewModel()))
    }

    private func makeChangeLanguageViewModel() -> ChangeLanguageViewModelImpl {
        return scoped(ChangeLanguageViewModelImpl())
    }
}
