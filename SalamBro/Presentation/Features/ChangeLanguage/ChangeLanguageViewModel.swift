//
//  ChangeLanguageViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import Foundation

protocol ChangeLanguageViewModel: AnyObject {}

final class ChangeLanguageViewModelImpl: ChangeLanguageViewModel {
    var selectionIndexPath: IndexPath?
    var marked: IndexPath?

    public let languages: [String] = [
        "Kazakh",
        "Russian",
        "English",
    ]

    init() {}
}

extension ChangeLanguageViewModelImpl {}
