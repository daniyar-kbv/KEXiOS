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

    func getLanguage(at index: Int) -> (language: Language, isCurrent: Bool)
    func changeLanguage(at index: Int)
}

final class ChangeLanguageViewModelImpl: ChangeLanguageViewModel {
    private let defaultStorage: DefaultStorage
    private(set) var outputs: Output = .init()

    let languages: [Language] = [.russian, .kazakh]

    init(defaultStorage: DefaultStorage) {
        self.defaultStorage = defaultStorage
    }

    func getLanguage(at index: Int) -> (language: Language, isCurrent: Bool) {
        return (languages[index], languages[index] == defaultStorage.appLocale)
    }

    func changeLanguage(at index: Int) {
        defaultStorage.persist(appLocale: languages[index])
        outputs.didChangeLanguage.accept(())
        outputs.didEnd.accept(())
    }
}

extension ChangeLanguageViewModelImpl {
    struct Output {
        let didChangeLanguage = PublishRelay<Void>()
        let didEnd = PublishRelay<Void>()
    }
}
