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
}

final class SBTabBarViewModelImpl: SBTabBarViewModel {
    private let documentsRepository: DocumentsRepository
    private let authRepository: AuthRepository

    init(documentsRepository: DocumentsRepository,
         authRepository: AuthRepository)
    {
        self.documentsRepository = documentsRepository
        self.authRepository = authRepository
    }

    func getDocuments() {
        documentsRepository.getDocuments()
    }

    func refreshToken() {
        authRepository.refreshToken()
    }
}
