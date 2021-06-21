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
    func makeAgreementPage() -> AgreementController
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
        return shared(SupportViewModelImpl())
    }

    func makeAgreementPage() -> AgreementController {
        return scoped(.init(viewModel: makeAgreementViewModel()))
    }

    private func makeAgreementViewModel() -> AgreementViewModel {
//        Tech debt: change to real url
        return scoped(AgreementViewModelImpl(url: URL(string: "google.kz")!))
    }
}
