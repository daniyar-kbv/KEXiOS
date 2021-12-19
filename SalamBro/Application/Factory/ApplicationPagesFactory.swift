//
//  ApplicationPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 7/5/21.
//

import Foundation

protocol ApplicationPagesFactory: AnyObject {
    func makeIntroVideoPage() -> IntroVideoController
    func makeSBTabbarController() -> SBTabBarController
}

final class ApplicationPagesFactoryImpl: DependencyFactory, ApplicationPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeIntroVideoPage() -> IntroVideoController {
        return .init(viewModel: makeIntroVideoViewModel())
    }

    private func makeIntroVideoViewModel() -> IntroVideoViewModel {
        return scoped(IntroVideoViewModelImpl())
    }

    func makeSBTabbarController() -> SBTabBarController {
        return shared(.init(viewModel: makeSBTabbarViewModel()))
    }

    private func makeSBTabbarViewModel() -> SBTabBarViewModel {
        return shared(SBTabBarViewModelImpl(
            documentsRepository: repositoryComponents.makeDocumentsRepository(),
            defaultStorage: DefaultStorageImpl.sharedStorage
        ))
    }
}
