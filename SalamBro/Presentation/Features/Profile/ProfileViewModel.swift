//
//  ProfileViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation

protocol ProfileViewModel: AnyObject {
    var tableItems: [ProfileTableItem] { get }
}

final class ProfileViewModelImpl: ProfileViewModel {
    private(set) var tableItems: [ProfileTableItem] = [
        .orderHistory,
        .changeLanguage,
        .deliveryAddress,
    ]

    private let profileService: ProfileService
    private let authService: AuthService

    init(profileService: ProfileService, authService: AuthService) {
        self.profileService = profileService
        self.authService = authService
    }
}
