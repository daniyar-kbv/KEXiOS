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
    func makeChangeLanguagePage() -> ChangeLanguageController
}

final class ProfilePagesFactoryImpl: DependencyFactory, ProfilePagesFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makeProfilePage() -> ProfilePage {
        return scoped(.init(viewModel: makeProfileViewModel()))
    }

    private func makeProfileViewModel() -> ProfileViewModel {
        return scoped(ProfileViewModelImpl(repository: repositoryComponents.makeProfileRepository()))
    }

    func makeChangeUserInfoPage(userInfo: UserInfoResponse) -> ChangeNameController {
        return scoped(.init(viewModel: makeChangeUserInfoViewModel(userInfo: userInfo)))
    }

    private func makeChangeUserInfoViewModel(userInfo: UserInfoResponse) -> ChangeNameViewModel {
        return scoped(ChangeNameViewModelImpl(repository: repositoryComponents.makeProfileRepository(), userInfo: userInfo))
    }

    func makeChangeLanguagePage() -> ChangeLanguageController {
        return scoped(.init(viewModel: makeChangeLanguageViewModel()))
    }

    private func makeChangeLanguageViewModel() -> ChangeLanguageViewModelImpl {
        return scoped(ChangeLanguageViewModelImpl(defaultStorage: DefaultStorageImpl.sharedStorage,
                                                  addressRepository: repositoryComponents.makeAddressRepository()))
    }
}
