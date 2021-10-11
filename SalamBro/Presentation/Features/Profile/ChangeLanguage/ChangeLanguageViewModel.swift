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
    private let disposeBag = DisposeBag()

    private let defaultStorage: DefaultStorage
    private(set) var outputs: Output = .init()

    private let addressRepository: AddressRepository

    let languages: [Language] = [.russian, .kazakh]

    init(defaultStorage: DefaultStorage, addressRepository: AddressRepository) {
        self.defaultStorage = defaultStorage
        self.addressRepository = addressRepository

        bindOutputs()
    }

    func getLanguage(at index: Int) -> (language: Language, isCurrent: Bool) {
        return (languages[index], languages[index] == defaultStorage.appLocale)
    }

    func changeLanguage(at index: Int) {
        defaultStorage.persist(appLocale: languages[index])
        addressRepository.getUserAddresses()
    }

    private func bindOutputs() {
        addressRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.outputs.didChangeLanguage.accept(())
                self?.outputs.didEndRequest.accept(())
            })
            .disposed(by: disposeBag)
    }
}

extension ChangeLanguageViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didChangeLanguage = PublishRelay<Void>()
    }
}
