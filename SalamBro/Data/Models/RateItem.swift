//
//  RateItem.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/28/21.
//

import Foundation

struct RateItem {
    var title: RateItemTitle
    var isSelected: Bool
}

extension RateItem {
    enum RateItemTitle {
        case notFound
        case foodIsMissing
        case foodIsCold
        case courierWork
        case givenTime
        case deliveryTime

        var title: String {
            switch self {
            case .notFound:
                return L10n.RateOrder.Cell.CourierNotFoundClient.text
            case .foodIsMissing:
                return L10n.RateOrder.Cell.FoodIsMissing.text
            case .foodIsCold:
                return L10n.RateOrder.Cell.FoodIsCold.text
            case .courierWork:
                return L10n.RateOrder.Cell.CourierWork.text
            case .givenTime:
                return L10n.RateOrder.Cell.GivenTime.text
            case .deliveryTime:
                return L10n.RateOrder.Cell.DeliveryTime.text
            }
        }
    }
}
