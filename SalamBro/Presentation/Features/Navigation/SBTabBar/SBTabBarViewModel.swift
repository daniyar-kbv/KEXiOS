//
//  SBTabBarViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/5/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol SBTabBarViewModel: AnyObject {
    func getDocuments()
    func refreshToken()
    func setFirstLauch()
}

final class SBTabBarViewModelImpl: SBTabBarViewModel {
    private let documentsRepository: DocumentsRepository
    private let authRepository: AuthRepository
    private let defaultStorage: DefaultStorage

    init(documentsRepository: DocumentsRepository,
         authRepository: AuthRepository,
         defaultStorage: DefaultStorage)
    {
        self.documentsRepository = documentsRepository
        self.authRepository = authRepository
        self.defaultStorage = defaultStorage
    }

    func getDocuments() {
        documentsRepository.getDocuments()
    }

    func refreshToken() {
        authRepository.refreshToken()
    }

    func setFirstLauch() {
        guard !defaultStorage.notFirstLaunch else { return }
        defaultStorage.persist(notFirstLaunch: true)
    }
}
