//
//  Language.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/28/21.
//

import UIKit

enum Language: String, CaseIterable {
    case russian = "ru"
    case kazakh = "kk"
    case english = "en"

    var icon: UIImage? {
        switch self {
        case .russian:
            return SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.russianLanguageIcon)
        case .kazakh:
            return SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.kazakhLanguageIcon)
        case .english:
            return SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.englishLanguageIcon)
        }
    }

    var title: String {
        switch self {
        case .russian: return SBLocalization.localized(key: ProfileText.ChangeLanguage.russian)
        case .kazakh: return SBLocalization.localized(key: ProfileText.ChangeLanguage.kazakh)
        case .english: return SBLocalization.localized(key: ProfileText.ChangeLanguage.english)
        }
    }

    var code: String { rawValue }

    static func get(by code: String?) -> Language {
        return Language(rawValue: code ?? Language.russian.code) ?? .russian
    }
}
