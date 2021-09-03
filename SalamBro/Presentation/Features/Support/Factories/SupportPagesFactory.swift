//
//  SupportPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import Foundation

protocol SupportPagesFactory: AnyObject {
    func makeSupportPage() -> SupportController
    func makeAgreementPage(url: URL, name: String) -> AgreementController
}

final class SupportPagesFactoryImpl: DependencyFactory, SupportPagesFactory {
    private let repositoryComponents: RepositoryComponents

    init(repositoryComponents: RepositoryComponents) {
        self.repositoryComponents = repositoryComponents
    }

    func makeSupportPage() -> SupportController {
        return scoped(.init(viewModel: makeSupportViewModel()))
    }

    private func makeSupportViewModel() -> SupportViewModel {
        return scoped(SupportViewModelImpl(documentsRepository: repositoryComponents.makeDocumentsRepository()))
    }

    func makeAgreementPage(url: URL, name: String) -> AgreementController {
        return scoped(.init(viewModel: makeAgreementViewModel(url: url, name: name)))
    }

    private func makeAgreementViewModel(url: URL, name: String) -> AgreementViewModel {
        return scoped(AgreementViewModelImpl(input: .init(url: url, name: name)))
    }
}
