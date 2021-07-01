//
//  CartProductViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/30/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartProductViewModel: AnyObject {
    var inputs: CartProductViewModelImpl.Input { get }
    var outputs: CartProductViewModelImpl.Output { get }

    func getPositionUUID() -> String
}

final class CartProductViewModelImpl: CartProductViewModel {
    let inputs: Input
    let outputs: Output

    init(inputs: Input) {
        self.inputs = inputs
        outputs = .init(item: inputs.item)
    }

    func getPositionUUID() -> String {
        return inputs.item.positionUUID
    }
}

extension CartProductViewModelImpl {
    struct Input {
        var item: CartItem
    }

    struct Output {
        let itemTitle: BehaviorRelay<String>
        let modifiersTitles: BehaviorRelay<String>
        let comment: BehaviorRelay<String>
        let price: BehaviorRelay<String>
        let count: BehaviorRelay<String>
        let isAvailable: BehaviorRelay<Bool>

        init(item: CartItem) {
            itemTitle = .init(value: item.position.name)
            modifiersTitles = .init(value: item.modifiers.map { $0.position.name }.joined(separator: ", "))
            comment = .init(value: item.comment)
            price = .init(value: "\(((item.position.price ?? 0) * Double(item.count)).removeTrailingZeros()) ₸")
            count = .init(value: String(item.count))
            isAvailable = .init(value: true)
        }
    }
}
