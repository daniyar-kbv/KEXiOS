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
}

final class SBTabBarViewModelImpl: SBTabBarViewModel {
    private let repository: DocumentsRepository

    init(repository: DocumentsRepository) {
        self.repository = repository
    }

    func getDocuments() {
        repository.getDocuments()
    }
}
