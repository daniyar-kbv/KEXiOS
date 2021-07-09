//
//  Language.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/28/21.
//

import UIKit

struct Language {
    var type: LanguageTableItem
    var checkmark: Bool
}

extension Language {
    enum LanguageTableItem {
        case kazakh
        case russian
        case english

        var icon: UIImage? {
            switch self {
            case .kazakh:
                return SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.kazakhLanguageIcon)
            case .russian:
                return SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.russianLanguageIcon)
            case .english:
                return SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.englishLanguageIcon)
            }
        }

        var title: String {
            switch self {
            case .kazakh: return "Kazakh"
            case .russian: return "Russian"
            case .english: return "English"
            }
        }
    }
}
