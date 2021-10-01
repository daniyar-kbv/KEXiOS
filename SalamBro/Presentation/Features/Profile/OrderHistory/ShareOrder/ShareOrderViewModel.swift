//
//  ShareOrderViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/23/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ShareOrderViewModel {
    var checkURL: BehaviorRelay<String> { get }
}

final class ShareOrderViewModelImpl: ShareOrderViewModel {
    var checkURL: BehaviorRelay<String>

    init(url: String) {
        checkURL = .init(value: url)
    }
}
