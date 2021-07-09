//
//  PaymentMethodPresentable.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import Foundation

protocol PaymentMethodSelectable {
    var isSelected: Bool { get set }
}

enum PaymentMethodType {
    case storedCard(String)
    case inApp
    case cash

    var title: String {
        switch self {
        case .cash: return "Наличными курьеру"
        case .inApp: return "Картой в приложении"
        case let .storedCard(value): return value
        }
    }
}

struct PaymentMethod: PaymentMethodSelectable {
    let paymentType: PaymentMethodType
    var isSelected: Bool = false
}

enum PaymentMethodError: ErrorPresentable {
    case incorrectIndexPath

    var presentationDescription: String {
        return "не валидный indexPath"
    }
}
