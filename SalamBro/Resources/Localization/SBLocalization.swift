//
//  SBLocalization.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 01.07.2021.
//

import Foundation

protocol UILocalizable {
    var localized: String { get }
}

enum TabBarText: UILocalizable {
    case profileTitle
    case menuTitle
    case supportTitle
    case cartTitle

    var localized: String {
        switch self {
        case .cartTitle: return "MainTab.Cart.Title"
        case .menuTitle: return "MainTab.Menu.Title"
        case .profileTitle: return "MainTab.Profile.Title"
        case .supportTitle: return "MainTab.Support.Title"
        }
    }
}

enum ProfileText {
    enum RateOrder: UILocalizable {
        case courierWork

        var localized: String {
            switch self {
            case .courierWork: return "RateOrder.cell.courierWork.text" = "Courier work"
                "RateOrder.cell.givenTime.text" = "Suggested time"
                "RateOrder.cell.courierNotFoundClient.text" = "The courier did not find me"
                "RateOrder.cell.foodIsMissing.text" = "Missing dish"
                "RateOrder.cell.foodIsCold.text" = "The food was cold"
                "RateOrder.cell.deliveryTime.text" = "Delivery time"
            }
        }
    }
}

enum PaymentSelectionText: UILocalizable {
    case title
    case paymentMethod
    case choosePaymentMethod
    case change
    case bill
    case orderPayment

    var localized: String {
        switch self {
        case .bill: return "Payment.Selection.bill"
        case .change: return "Payment.Selection.change"
        case .choosePaymentMethod: return "Payment.Selection.choosePaymentMethod"
        case .orderPayment: return "Payment.Selection.orderPayment"
        case .paymentMethod: return "Payment.Selection.paymentMethod"
        case .title: return "Payment.Selection.title"
        }
    }
}

enum SBLocalization {
    static func localized(key: UILocalizable, arguments: String? = nil) -> String {
        guard
            let language = DefaultStorageImpl.sharedStorage.appLocale,
            let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(key.localized, tableName: "Localizable", comment: "")
        }

        if let arguments = arguments {
            let localizedString = NSLocalizedString(key.localized, tableName: "Localizable", bundle: bundle, comment: "")
            return String(format: localizedString, arguments)
        }

        return NSLocalizedString(key.localized, tableName: "Localizable", bundle: bundle, comment: "")
    }
}
