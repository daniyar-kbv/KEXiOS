//
//  CartAdditionalProductViewModel.swift
//  SalamBro
//
//  Created by Dan on 8/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartAdditionalProductViewModel: CartCellViewModel {
    var inputs: CartAdditionalProductViewModelImpl.Input { get }
    var outputs: CartAdditionalProductViewModelImpl.Output { get }

    func getPositionUUID() -> String
}

final class CartAdditionalProductViewModelImpl: CartAdditionalProductViewModel {
    let inputs: Input
    let outputs: Output

    init(inputs: Input) {
        self.inputs = inputs
        outputs = .init(item: inputs.item)
    }

    func getPositionUUID() -> String {
        return inputs.item.position.uuid
    }
}

extension CartAdditionalProductViewModelImpl {
    struct Input {
        var item: CartItem
    }

    struct Output {
        let itemImage: BehaviorRelay<URL?>
        let itemTitle: BehaviorRelay<String>
        let price: BehaviorRelay<String>
        let count: BehaviorRelay<String>

        init(item: CartItem) {
            itemImage = .init(value: URL(string: item.position.image ?? ""))
            itemTitle = .init(value: item.position.name)
            price = .init(value: "\(((item.position.price ?? 0) * Double(item.count)).formattedWithSeparator) ₸")
            count = .init(value: String(item.count))
        }
    }
}
