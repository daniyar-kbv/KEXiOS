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
        case .orderHistory: return SBImageResource.getIcon(for: ProfileIcon.orderHistoryIcon)
        case .deliveryAddress: return SBImageResource.getIcon(for: ProfileIcon.deliveryAddressIcon)
        case .changeLanguage: return SBImageResource.getIcon(for: ProfileIcon.changeLanguageIcon)
        }
    }

    var title: String {
        switch self {
        case .changeLanguage: return L10n.Profile.changeLanguage
        case .deliveryAddress: return L10n.Profile.deliveryAddress
        case .orderHistory: return L10n.Profile.orderHistory
        }
    }
}
