//
//  AgreementViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/16/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AgreementViewModel {
    var inputs: AgreementViewModelImpl.Input { get }
    var ouputs: AgreementViewModelImpl.Output { get }
}

class AgreementViewModelImpl: AgreementViewModel {
    let inputs: Input
    let ouputs: Output

    init(input: Input) {
        inputs = input
        ouputs = .init(url: input.url, name: input.name)
    }
}

extension AgreementViewModelImpl {
    struct Input {
        let url: URL
        let name: String?
    }

    struct Output {
        let url: BehaviorRelay<URL>
        let name: BehaviorRelay<String?>

        init(url: URL, name: String?) {
            self.url = .init(value: url)
            self.name = .init(value: name)
        }
    }
}
