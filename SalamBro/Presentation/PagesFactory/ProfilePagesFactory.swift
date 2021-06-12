//
//  ProfilePagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 12.06.2021.
//

import Foundation

protocol ProfilePagesFactory: AnyObject {
    func makeProfilePage() -> ProfilePage
    func makeChangeUserInfoPage() -> ChangeNameController // FIXME: Нужно переписать этот class
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
        return scoped(ProfileViewModelImpl())
    }

    /// Нужно переписать используя viewModel, snapkit и rxswift
    func makeChangeUserInfoPage() -> ChangeNameController {
        return scoped(.init(nibName: nil, bundle: nil))
    }

    /// Нужно переписать  используя viewModel, snapkit и rxswift
    func makeChangeLanguagePage() -> ChangeLanguageController {
        return scoped(.init(nibName: nil, bundle: nil))
    }
}
