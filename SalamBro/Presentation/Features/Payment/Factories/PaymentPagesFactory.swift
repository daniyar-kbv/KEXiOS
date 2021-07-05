//
//  PaymentPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation

protocol PaymentPagesFactory: AnyObject {
    func makePaymentSelectionPage() -> PaymentSelectionViewController
}

final class PaymentPagesFactoryImpl: DependencyFactory, PaymentPagesFactory {
    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents

    init(serviceComponents: ServiceComponents, repositoryComponents: RepositoryComponents) {
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
    }

    func makePaymentSelectionPage() -> PaymentSelectionViewController {
        return scoped(.init(viewModel: makePaymentSelectionViewModel()))
    }

    private func makePaymentSelectionViewModel() -> PaymentSelectionViewModel {
        return scoped(PaymentSelectionViewModelImpl())
    }
}
