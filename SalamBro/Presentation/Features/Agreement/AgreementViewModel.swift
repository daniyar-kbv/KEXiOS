//
//  WebViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/16/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol AgreementViewModel {
    var url: BehaviorRelay<URL> { get }
}

class AgreementViewModelImpl: AgreementViewModel {
    let url: BehaviorRelay<URL>

    init(url: URL) {
        self.url = BehaviorRelay<URL>(value: url)
    }
}
