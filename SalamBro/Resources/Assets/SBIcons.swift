//
//  SBIcons.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import UIKit

protocol UIImageGetable {
    var name: String { get }
}

enum ProfileIcon: String, UIImageGetable {
    case changeLanguageIcon = "change_language_icon"
    case deliveryAddressIcon = "delivery_address_icon"
    case orderHistoryIcon = "order_history_icon"

    case kazakhLanguageIcon = "kazakh_language_icon"
    case russianLanguageIcon = "russian_language_icon"
    case englishLanguageIcon = "english_language_icon"

    var name: String { return rawValue }
}

enum AddressListIcon: String, UIImageGetable {
    case addressRemoveIcon = "address_remove_icon"

    var name: String { return rawValue }
}

enum SupportIcon: String, UIImageGetable {
    case documentsIcon = "support_documents_icon"
    case instagramIcon = "instagram_icon"
    case mailIcon = "mail_icon"
    case tikTokIcon = "tik_tok_icon"
    case vkIcon = "vk_icon"

    var name: String { return rawValue }
}

enum SBImageResource {
    static func getIcon(for icon: UIImageGetable) -> UIImage? {
        return UIImage(named: icon.name)
    }
}
