//
//  SBLocalization.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 01.07.2021.
//

import Foundation

enum LocalizationKey: String {
    case tabbarProfileTitle = "MainTab.Profile.Title"
    case tabbarMenuTitle = "MainTab.Menu.Title"
    case tabbarSupportTitle = "MainTab.Support.Title"
    case tabbarCartTitle = "MainTab.Cart.Title"
}

enum SBLocalization {
    static func localized(key: LocalizationKey, arguments: String? = nil) -> String {
        guard
            let language = DefaultStorageImpl.sharedStorage.appLocale,
            let path = Bundle.main.path(forResource: language, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(key.rawValue, tableName: "Localizable", comment: "")
        }

        if let arguments = arguments {
            let localizedString = NSLocalizedString(key.rawValue, tableName: "Localizable", bundle: bundle, comment: "")
            return String(format: localizedString, arguments)
        }

        return NSLocalizedString(key.rawValue, tableName: "Localizable", bundle: bundle, comment: "")
    }
}
