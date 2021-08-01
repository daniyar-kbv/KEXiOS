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
            guard let card = value as? MyCard else { return "" }
            return SBLocalization.localized(key: PaymentText.PaymentMethod.MethodTitle.savedCard, arguments: card.cardMaskedNumber)
        case .card: return SBLocalization.localized(key: PaymentText.PaymentMethod.MethodTitle.card)
        case .cash: return SBLocalization.localized(key: PaymentText.PaymentMethod.MethodTitle.cash)
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
            return lhs.value as? MyCard == rhs.value as? MyCard
        case .card:
            return lhs.value as? PaymentCard == rhs.value as? PaymentCard
        case .cash:
            return lhs.value as? Int == rhs.value as? Int
        }
    }
}

enum PaymentMethodError: ErrorPresentable {
    case incorrectIndexPath

    var presentationDescription: String {
        return SBLocalization.localized(key: PaymentText.PaymentMethod.errorDescription)
    }
}
