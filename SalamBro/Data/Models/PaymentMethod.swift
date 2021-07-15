//
//  PaymentMethod.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation

enum PaymentMethodType {
    case savedCard
    case card
    case cash

    var apiType: String {
        switch self {
        case .savedCard: return ""
        case .card: return "DEBIT_CARD"
        case .cash: return ""
        }
    }
}

class PaymentMethod {
    let type: PaymentMethodType
    private var value: Any?

    init(type: PaymentMethodType,
         value: Any? = nil)
    {
        self.type = type
        self.value = value
    }

    var title: String {
        switch type {
        case .savedCard:
            guard let card = value as? SavedCard else { return "" }
            return "Карта *\(card.lastFourDigits)"
        case .card: return "Картой в приложении"
        case .cash: return "Наличными курьеру"
        }
    }

    func set(value: Any) {
        self.value = value
    }

    func getValue<T>() -> T? {
        return value as? T
    }
}

extension PaymentMethod: Equatable {
    static func == (lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
        if lhs.type != rhs.type {
            return false
        }

        switch lhs.type {
        case .savedCard:
            return lhs.value as? SavedCard == rhs.value as? SavedCard
        case .card:
            return lhs.value as? PaymentCard == rhs.value as? PaymentCard
        case .cash:
            return lhs.value as? Int == rhs.value as? Int
        }
    }
}

enum PaymentMethodError: ErrorPresentable {
    case incorrectIndexPath

//        Tech debt: localize
    var presentationDescription: String {
        return "не валидный indexPath"
    }
}
