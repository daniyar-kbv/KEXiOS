//
//  PromotionsViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/23/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PromotionsViewModel {
    var inputs: PromotionsViewModelImpl.Input { get }
    var ouputs: PromotionsViewModelImpl.Output { get }

    func getToken() -> String
    func getLeadUUID() -> String
}

class PromotionsViewModelImpl: PromotionsViewModel {
    private let authTokenStorage: AuthTokenStorage
    private let defaultStorage: DefaultStorage

    let inputs: Input
    let ouputs: Output

    init(input: Input, authTokenStorage: AuthTokenStorage, defaultStorage: DefaultStorage) {
        inputs = input
        ouputs = .init(url: input.url, name: input.name, redirectURL: input.redirectURL)
        self.authTokenStorage = authTokenStorage
        self.defaultStorage = defaultStorage
    }

    func getToken() -> String {
        guard let token = authTokenStorage.token else { return "" }
        return token
    }

    func getLeadUUID() -> String {
        guard let leadUUID = defaultStorage.leadUUID else { return "" }
        return leadUUID
    }
}

extension PromotionsViewModelImpl {
    struct Input {
        let url: URL
        let name: String?
        let redirectURL: String
    }

    struct Output {
        let url: BehaviorRelay<URL>
        let name: BehaviorRelay<String?>
        let redirectURL: BehaviorRelay<String>

        init(url: URL, name: String?, redirectURL: String) {
            self.url = .init(value: url)
            self.name = .init(value: name)
            self.redirectURL = .init(value: redirectURL)
        }
    }
}
