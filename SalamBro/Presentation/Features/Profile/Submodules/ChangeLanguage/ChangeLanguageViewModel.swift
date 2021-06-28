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
    var languages: [Language] { get }
    var outputs: ChangeLanguageViewModelImpl.Output { get }

    func getLanguage(at index: Int) -> Language
    func changeLanguage(at index: Int)
}

final class ChangeLanguageViewModelImpl: ChangeLanguageViewModel {
    private(set) var languages: [Language] = [
        Language(type: .kazakh, checkmark: false), Language(type: .russian, checkmark: true), Language(type: .english, checkmark: false),
    ]

    private(set) var outputs: Output = .init()

    init() {}

    func changeLanguage(at index: Int) {
        configureLanguages(at: index)
        outputs.didChangeLanguage.accept(index)
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
        let didChangeLanguage = PublishRelay<Int>()
        let didEnd = PublishRelay<Void>()
    }
}
