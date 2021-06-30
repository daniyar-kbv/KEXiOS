//
//  CartProductViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/30/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartProductViewModel {
    var outputs: CartProductViewModelImpl.Output { get }

    func getPositionUUID() -> String
}

final class CartProductViewModelImpl: CartProductViewModel {
    private let item: CartItem

    let outputs: Output

    init(item: CartItem) {
        self.item = item
        outputs = .init(item: item)
    }

    func getPositionUUID() -> String {
        return item.positionUUID
    }
}

extension CartProductViewModelImpl {
    struct Output {
        let itemTitle: BehaviorRelay<String>
        let modifiersTitles: BehaviorRelay<String>
        let comment: BehaviorRelay<String>
        let price: BehaviorRelay<String>
        let count: BehaviorRelay<String>
        let isAvailable: BehaviorRelay<Bool>

        init(item: CartItem) {
            print("Comment: \(item.comment)")

            itemTitle = .init(value: item.position.name)
            modifiersTitles = .init(value: item.modifiers.map { $0.position.name }.joined(separator: ", "))
            comment = .init(value: item.comment)
            price = .init(value: "\(((item.position.price ?? 0) * Double(item.count)).removeTrailingZeros()) ₸")
            count = .init(value: String(item.count))
            isAvailable = .init(value: true)
        }
    }
}
