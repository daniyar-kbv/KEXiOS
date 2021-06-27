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
    var url: BehaviorRelay<URL> { get }
}

final class ShareOrderViewModelImpl: ShareOrderViewModel {
    let url: BehaviorRelay<URL>

    init(url: URL) {
        self.url = BehaviorRelay<URL>(value: url)
    }
}
