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
        case .changeLanguage: return L10n.Profile.changeLanguage
        case .deliveryAddress: return L10n.Profile.deliveryAddress
        case .orderHistory: return L10n.Profile.orderHistory
        }
    }
}
