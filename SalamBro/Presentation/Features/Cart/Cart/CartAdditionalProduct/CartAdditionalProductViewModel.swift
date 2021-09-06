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

    func getItem() -> CartItem
    func isInUsersCart() -> Bool
}

final class CartAdditionalProductViewModelImpl: CartAdditionalProductViewModel {
    let inputs: Input
    let outputs: Output

    private let cartRepository: CartRepository

    init(inputs: Input, cartRepository: CartRepository) {
        self.inputs = inputs
        self.cartRepository = cartRepository
        outputs = .init(item: inputs.item)
    }

    func getItem() -> CartItem {
        return inputs.item
    }

    func isInUsersCart() -> Bool {
        return cartRepository.getLocalCart().items.contains(inputs.item)
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
        let isAvailable: BehaviorRelay<Bool>

        init(item: CartItem) {
            itemImage = .init(value: URL(string: item.position.image ?? ""))
            itemTitle = .init(value: item.position.name)
            price = .init(value: "\((item.position.price ?? 0).formattedWithSeparator) ₸")
            count = .init(value: String(item.count))
            isAvailable = .init(value: item.position.isAvailable)
        }
    }
}
