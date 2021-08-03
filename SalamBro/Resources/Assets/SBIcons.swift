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

enum NavigationBar: String, UIImageGetable {
    case back = "navigation_back"

    var name: String { rawValue }
}

enum TabBarIcon: String, UIImageGetable {
    case menu = "tab_menu"
    case profile = "tab_profile"
    case support = "tab_support"
    case cart = "tab_cart"

    var name: String { rawValue }
}

enum AuthorizationIcons {
    enum Auth: String, UIImageGetable {
        case arrow = "auth_arrow"

        var name: String { rawValue }
    }
}

enum AddressIcons {
    enum Map: String, UIImageGetable {
        case backButton = "map_back_button"
        case location = "map_location"
        case marker = "map_marker"
        case arrow = "map_arrow"

        var name: String { rawValue }
    }

    enum Suggest: String, UIImageGetable {
        case search = "suggest_search"

        var name: String { rawValue }
    }

    enum AddressPick: String, UIImageGetable {
        case arrowRightIcon = "address_pick_arrow_right"
        case checkMarkIcon = "address_pick_check_mark"
        case add = "address_pick_add"

        var name: String { rawValue }
    }

    enum SelectMainInfo: String, UIImageGetable {
        case arrow = "select_main_info_dropdown"

        var name: String { rawValue }
    }
}

enum MenuIcons {
    enum Menu: String, UIImageGetable {
        case arrow = "menu_arrow"

        var name: String { rawValue }
    }
}

enum ProfileIcons {
    enum Profile: String, UIImageGetable {
        case changeLanguageIcon = "profile_change_language_icon"
        case deliveryAddressIcon = "profile_delivery_address_icon"
        case orderHistoryIcon = "profile_order_history_icon"

        var name: String { rawValue }
    }

    enum AddressList: String, UIImageGetable {
        case addressRemoveIcon = "address_list_remove_icon"
        case addressArrow = "address_list_arrow"

        var name: String { rawValue }
    }

    enum ChangeLanguage: String, UIImageGetable {
        case kazakhLanguageIcon = "kazakh_language_icon"
        case russianLanguageIcon = "russian_language_icon"
        case englishLanguageIcon = "english_language_icon"
        case chackMark = "change_language_check_mark"

        var name: String { rawValue }
    }

    enum RateOrder: String, UIImageGetable {
        case starFilled = "rate_star_filled"
        case starEmpty = "rate_star_empty"

        var name: String { rawValue }
    }
}

enum SupportIcons {
    enum Support: String, UIImageGetable {
        case documentsIcon = "support_documents_icon"
        case instagramIcon = "instagram_icon"
        case mailIcon = "mail_icon"
        case tikTokIcon = "tik_tok_icon"
        case vkIcon = "vk_icon"

        var name: String { rawValue }
    }
}

enum CartIcons {
    enum Cart: String, UIImageGetable {
        case plusGray = "cart_plus_gray"
        case plusWhite = "cart_plus_white"
        case minus = "cart_minus"

        var name: String { rawValue }
    }
}

enum PaymentIcons {
    enum PaymentSelection: String, UIImageGetable {
        case applePay = "payment_apple_pay"

        var name: String { rawValue }
    }

    enum PaymentMethod: String, UIImageGetable {
        case selected = "payment_method_check_mark"
        case applePay = "payment_method_apple_pay"
        case edit = "payment_method_edit"

        var name: String { rawValue }
    }

    enum PaymentEdit: String, UIImageGetable {
        case delete = "payment_edit_trash"

        var name: String { rawValue }

        enum Checkmark: String, UIImageGetable {
            case empty = "payment_edit_checkmark_empty"
            case filled = "payment_edit_checkmark_filled"

            var name: String { rawValue }
        }
    }
}

enum SBImageResource {
    static func getIcon(for icon: UIImageGetable) -> UIImage? {
        return UIImage(named: icon.name)
    }
}
