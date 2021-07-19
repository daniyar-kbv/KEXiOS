//
//  PaymentPagesFactory.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation

protocol PaymentPagesFactory: AnyObject {
    func makePaymentSelectionPage() -> PaymentSelectionViewController
    func makePaymentMethodPage() -> PaymentMethodViewController
    func makePaymentCardPage(paymentMethod: PaymentMethod) -> PaymentCardViewController
    func makePaymentCashPage(paymentMethod: PaymentMethod) -> PaymentCashViewController
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
        return scoped(PaymentSelectionViewModelImpl(
            paymentRepository: repositoryComponents.makePaymentRepository(),
            menuRepository: repositoryComponents.makeMenuRepository(),
            cartRepository: repositoryComponents.makeCartRepository(),
            defaultStorage: DefaultStorageImpl.sharedStorage
        )
        )
    }

    func makePaymentMethodPage() -> PaymentMethodViewController {
        return scoped(.init(viewModel: makePaymentMethodVCViewModel()))
    }

    private func makePaymentMethodVCViewModel() -> PaymentMethodVCViewModel {
        return scoped(PaymentMethodVCViewModelImpl(paymentRepository: repositoryComponents.makePaymentRepository()))
    }

    func makePaymentCardPage(paymentMethod: PaymentMethod) -> PaymentCardViewController {
        return scoped(.init(viewModel: makePaymentCardViewModel(paymentMethod: paymentMethod)))
    }

    private func makePaymentCardViewModel(paymentMethod: PaymentMethod) -> PaymentCardViewModel {
        return scoped(PaymentCardViewModelImpl(
            paymentRepository: repositoryComponents.makePaymentRepository(),
            paymentMethod: paymentMethod
        ))
    }

    func makePaymentCashPage(paymentMethod: PaymentMethod) -> PaymentCashViewController {
        return scoped(.init(viewModel: makePaymentCashViewModel(paymentMethod: paymentMethod)))
    }

    private func makePaymentCashViewModel(paymentMethod: PaymentMethod) -> PaymentCashViewModel {
        return scoped(PaymentCashViewModelImpl(
            paymentRepository: repositoryComponents.makePaymentRepository(),
            paymentMethod: paymentMethod
        ))
    }
}
