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
                return SBLocalization.localized(key: ProfileText.RateOrder.Item.clientNotFound)
            case .foodIsMissing:
                return SBLocalization.localized(key: ProfileText.RateOrder.Item.missingFood)
            case .foodIsCold:
                return SBLocalization.localized(key: ProfileText.RateOrder.Item.coldFood)
            case .courierWork:
                return SBLocalization.localized(key: ProfileText.RateOrder.Item.courierWork)
            case .givenTime:
                return SBLocalization.localized(key: ProfileText.RateOrder.Item.givenTime)
            case .deliveryTime:
                return SBLocalization.localized(key: ProfileText.RateOrder.Item.deliveryTime)
            }
        }
    }
}
