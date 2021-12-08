//
//  PaymentMethodOutput.swift
//  SalamBro
//
//  Created by Daniyar Kurmanbayev on 2021-12-08.
//

import Foundation

enum PaymentMethodOutput: String, Codable {
    case debitCard = "DEBIT_CARD"
    case webWidget = "WEB_WIDGET"
    case googlepay = "GOOGLE_PAY"
    case applePay = "APPLE_PAY"
    case cash = "CASH"

    var title: String {
        switch self {
        case .debitCard, .webWidget: return SBLocalization.localized(key: PaymentText.PaymentMethod.TitleOutput.card)
        case .applePay: return SBLocalization.localized(key: PaymentText.PaymentMethod.TitleOutput.applePay)
        case .googlepay: return SBLocalization.localized(key: PaymentText.PaymentMethod.TitleOutput.googlePay)
        case .cash: return SBLocalization.localized(key: PaymentText.PaymentMethod.TitleOutput.cash)
        }
    }
}
