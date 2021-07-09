//
//  PaymentMethodViewModel.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation

protocol PaymentMethodViewModel: AnyObject {
    func getCountOfPaymentMethods() -> Int
    func getPaymentMethod(for indexPath: IndexPath)
        -> PaymentMethod
}

final class PaymentMethodViewModelImpl: PaymentMethodViewModel {
    var mockData: [PaymentMethod] = [
        //        Tech debt: localize
        .init(paymentType: .storedCard("Карта *9023")),
        .init(paymentType: .inApp, isSelected: true),
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
