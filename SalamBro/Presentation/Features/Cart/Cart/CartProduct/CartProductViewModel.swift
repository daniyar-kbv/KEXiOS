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
        let comment: BehaviorRelay<String>
        let price: BehaviorRelay<String>
        let count: BehaviorRelay<String>
        let isAvailable: BehaviorRelay<Bool>

        init(item: CartItem) {
            itemImage = .init(value: URL(string: item.position.image ?? ""))
            itemTitle = .init(value: item.position.name)
            modifiersTitles = .init(value: item.modifierGroups
                .flatMap { $0.modifiers }
                .map { $0.position.name }
                .joined(separator: ", "))
            comment = .init(value: item.comment)
            price = .init(value: "\((item.position.price ?? 0).formattedWithSeparator) ₸")
            count = .init(value: String(item.count))
            isAvailable = .init(value: true)
        }
    }
}
