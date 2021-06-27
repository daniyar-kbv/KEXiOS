//
//  ChangeLanguageViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import UIKit

protocol ChangeLanguageViewModel: AnyObject {}

final class ChangeLanguageViewModelImpl: ChangeLanguageViewModel {
    var isMarked: Bool?

    private(set) var languages: [String] = [
        "Kazakh",
        "Russian",
        "English",
    ]

    init() {}

    func getLanguage(at indexPath: IndexPath) -> String {
        return languages[indexPath.row]
    }

    func getImage(at indexPath: IndexPath) -> UIImage {
        return UIImage(named: languages[indexPath.row].lowercased()) ?? UIImage()
    }
}

extension ChangeLanguageViewModelImpl {}
