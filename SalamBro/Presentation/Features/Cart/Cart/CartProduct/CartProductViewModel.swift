//
//  CartProductViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/30/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartProductViewModel: CartCellViewModel {
    var inputs: CartProductViewModelImpl.Input { get }
    var outputs: CartProductViewModelImpl.Output { get }

    func getInternalUUID() -> String
}

final class CartProductViewModelImpl: CartProductViewModel {
    let inputs: Input
    let outputs: Output

    init(inputs: Input) {
        self.inputs = inputs
        outputs = .init(item: inputs.item)
    }

    func getInternalUUID() -> String {
        return inputs.item.internalUUID
    }
}

extension CartProductViewModelImpl {
    struct Input {
        var item: CartItem
    }

    struct Output {
        let itemImage: BehaviorRelay<URL?>
        let itemTitle: BehaviorRelay<String>
        let modifiersTitles: BehaviorRelay<String>
        let comment: BehaviorRelay<String?>
        let price: BehaviorRelay<String>
        let count: BehaviorRelay<String>
        let isAvailable: BehaviorRelay<Bool>

        init(item: CartItem) {
            itemImage = .init(value: URL(string: item.position.image ?? ""))
            itemTitle = .init(value: item.position.name)
            modifiersTitles = .init(value: item.modifiers
                .map { [String].init(repeating: $0.position.name, count: $0.count) }
                .flatMap { $0 }
                .joined(separator: ", "))
            comment = .init(value: item.comment)

            let modifiersPrice = item
                .modifiers
                .map { Double($0.count) * ($0.position.price ?? 0) }
                .reduce(0, +)
            let totalPrice = (item.position.price ?? 0) + modifiersPrice

            price = .init(value: SBLocalization.localized(
                key: CartText.Cart.Footer.productsPrice,
                arguments: totalPrice.formattedWithSeparator
            ))

            count = .init(value: String(item.count))
            isAvailable = .init(value: item.position.isAvailable)
        }
    }
}
