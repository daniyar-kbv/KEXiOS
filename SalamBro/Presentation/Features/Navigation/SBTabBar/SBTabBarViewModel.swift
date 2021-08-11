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
    func setFirstLauch()
}

final class SBTabBarViewModelImpl: SBTabBarViewModel {
    private let documentsRepository: DocumentsRepository
    private let defaultStorage: DefaultStorage

    init(documentsRepository: DocumentsRepository,
         defaultStorage: DefaultStorage)
    {
        self.documentsRepository = documentsRepository
        self.defaultStorage = defaultStorage
    }

    func getDocuments() {
        documentsRepository.getDocuments()
    }

    func setFirstLauch() {
        guard !defaultStorage.notFirstLaunch else { return }
        defaultStorage.persist(notFirstLaunch: true)
    }
}
