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
    var checkURL: BehaviorRelay<URL?> { get }

    func update()
}

final class ShareOrderViewModelImpl: ShareOrderViewModel {
    let checkURL = BehaviorRelay<URL?>(value: nil)

    private var checkURLString: String?

    init(url: String) {
        checkURLString = url
    }

    func update() {
        guard let checkURLString = checkURLString, let url = URL(string: checkURLString) else { return }
        checkURL.accept(url)
    }
}
