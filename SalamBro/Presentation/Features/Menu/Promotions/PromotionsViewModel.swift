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
}

class PromotionsViewModelImpl: PromotionsViewModel {
    private let authTokenStorage: AuthTokenStorage

    let inputs: Input
    let ouputs: Output

    init(input: Input, authTokenStorage: AuthTokenStorage) {
        inputs = input
        ouputs = .init(url: input.url, name: input.name, redirectURL: input.redirectURL)
        self.authTokenStorage = authTokenStorage
    }

    func getToken() -> String {
        guard let token = authTokenStorage.token else { return "" }
        return token
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
