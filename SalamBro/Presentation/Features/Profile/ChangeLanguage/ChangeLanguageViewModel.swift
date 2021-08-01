//
//  ChangeLanguageViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ChangeLanguageViewModel: AnyObject {
    var outputs: ChangeLanguageViewModelImpl.Output { get }

    var languages: [Language] { get }

    func getLanguage(at index: Int) -> Language
    func changeLanguage(at index: Int)
}

final class ChangeLanguageViewModelImpl: ChangeLanguageViewModel {
    private let defaultStorage: DefaultStorage
    private let languageTypes: [Language.LanguageTableItem] = [.russian, .kazakh, .english]

    private(set) var outputs: Output = .init()
    private(set) var languages: [Language]

    init(defaultStorage: DefaultStorage) {
        self.defaultStorage = defaultStorage

        languages = languageTypes
            .map { Language(type: $0, checkmark: defaultStorage.appLocale == $0.code) }
    }

    func changeLanguage(at index: Int) {
        configureLanguages(at: index)
        defaultStorage.persist(appLocale: languages[index].type)
        outputs.didChangeLanguage.accept(())
        outputs.didEnd.accept(())
    }

    func getLanguage(at index: Int) -> Language {
        return languages[index]
    }

    private func configureLanguages(at index: Int) {
        for i in 0 ..< languages.count { languages[i].checkmark = false }
        languages[index].checkmark = true
    }
}

extension ChangeLanguageViewModelImpl {
    struct Output {
        let didChangeLanguage = PublishRelay<Void>()
        let didEnd = PublishRelay<Void>()
    }
}
