//
//  SupportPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 18.06.2021.
//

import Foundation

protocol SupportPagesFactory: AnyObject {
    /// Rout View Controller for Coordinator
    func makeSupportPage() -> SupportController
    func makeAgreementPage(url: URL) -> AgreementController
}

final class SupportPagesFactoryImpl: DependencyFactory, SupportPagesFactory {
    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents) {
        self.serviceComponents = serviceComponents
    }

    func makeSupportPage() -> SupportController {
        return shared(.init(viewModel: makeSupportViewModel()))
    }

    private func makeSupportViewModel() -> SupportViewModel {
        return shared(SupportViewModelImpl(documentsService: serviceComponents.documentsService()))
    }

    func makeAgreementPage(url: URL) -> AgreementController {
        return scoped(.init(viewModel: makeAgreementViewModel(url: url)))
    }

    private func makeAgreementViewModel(url: URL) -> AgreementViewModel {
        return scoped(AgreementViewModelImpl(url: url))
    }
}
