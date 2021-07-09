//
//  ProfileTableItem.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import UIKit

enum ProfileTableItem {
    case orderHistory
    case changeLanguage
    case deliveryAddress

    var icon: UIImage? {
        switch self {
        case .orderHistory: return SBImageResource.getIcon(for: ProfileIcons.Profile.orderHistoryIcon)
        case .deliveryAddress: return SBImageResource.getIcon(for: ProfileIcons.Profile.deliveryAddressIcon)
        case .changeLanguage: return SBImageResource.getIcon(for: ProfileIcons.Profile.changeLanguageIcon)
        }
    }

    var title: String {
        switch self {
        case .changeLanguage: return SBLocalization.localized(key: ProfileText.Profile.changeLanguage)
        case .deliveryAddress: return SBLocalization.localized(key: ProfileText.Profile.deliveryAddress)
        case .orderHistory: return SBLocalization.localized(key: ProfileText.Profile.orderHistory)
        }
    }
}
