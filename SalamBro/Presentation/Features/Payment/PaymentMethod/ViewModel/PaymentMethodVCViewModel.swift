//
//  PaymentMethodVCViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation

protocol PaymentMethodVCViewModel: AnyObject {
    func getCountOfPaymentMethods() -> Int
    func getPaymentMethod(for indexPath: IndexPath)
        -> PaymentMethod
}

final class PaymentMethodVCViewModelImpl: PaymentMethodVCViewModel {
    var mockData: [PaymentMethod] = [
        //        Tech debt: localize
        .init(paymentType: .storedCard("Карта *9023")),
        .init(paymentType: .card, isSelected: true),
        .init(paymentType: .cash),
    ]

    init() {}

    func getCountOfPaymentMethods() -> Int {
        return mockData.count
    }

    func getPaymentMethod(for indexPath: IndexPath) -> PaymentMethod {
        return mockData[indexPath.row]
    }
}
