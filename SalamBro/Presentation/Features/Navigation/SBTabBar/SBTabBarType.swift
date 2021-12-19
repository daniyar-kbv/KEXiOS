//
//  SBTabBarType.swift
//  SalamBro
//
//  Created by Dan on 8/12/21.
//

import Foundation
import UIKit

enum SBTabBarType {
    case menu
    case profile
    case support
    case cart

    var tabBarItem: UITabBarItem {
        return .init(title: title, image: image, selectedImage: selectedImage)
    }

    private var title: String {
        switch self {
        case .menu: return SBLocalization.localized(key: TabBarText.menuTitle)
        case .profile: return SBLocalization.localized(key: TabBarText.profileTitle)
        case .support: return SBLocalization.localized(key: TabBarText.supportTitle)
        case .cart: return SBLocalization.localized(key: TabBarText.cartTitle)
        }
    }

    private var image: UIImage? {
        switch self {
        case .menu: return SBImageResource.getIcon(for: TabBarIcon.menu)
        case .profile: return SBImageResource.getIcon(for: TabBarIcon.profile)
        case .support: return SBImageResource.getIcon(for: TabBarIcon.support)
        case .cart: return SBImageResource.getIcon(for: TabBarIcon.cart)
        }
    }

    private var selectedImage: UIImage? {
        switch self {
        case .menu: return SBImageResource.getIcon(for: TabBarIcon.menu)
        case .profile: return SBImageResource.getIcon(for: TabBarIcon.profile)
        case .support: return SBImageResource.getIcon(for: TabBarIcon.support)
        case .cart: return SBImageResource.getIcon(for: TabBarIcon.cart)
        }
    }
}
