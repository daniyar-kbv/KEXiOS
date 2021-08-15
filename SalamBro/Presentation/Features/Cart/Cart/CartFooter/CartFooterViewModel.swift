//
//  CartFooterViewModel.swift
//  SalamBro
//
//  Created by Dan on 8/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartFooterViewModel {
    var outputs: CartFooterViewModelImpl.Output { get }
}

final class CartFooterViewModelImpl: CartFooterViewModel, CartCellViewModel {
    let outputs: Output

    init(input: Input) {
        outputs = .init(
            countText: .init(value: SBLocalization.localized(key: CartText.Cart.Footer.productsCount,
                                                             arguments: String(input.count))),
            productsPrice: .init(value: SBLocalization.localized(key: CartText.Cart.Footer.productsPrice,
                                                                 arguments: input.productsPrice.formattedWithSeparator)),
            deliveryPrice: .init(value: SBLocalization.localized(key: CartText.Cart.Footer.productsPrice,
                                                                 arguments: input.delivaryPrice.formattedWithSeparator))
        )
    }
}

extension CartFooterViewModelImpl {
    struct Input {
        let count: Int
        let productsPrice: Double
        let delivaryPrice: Double
    }

    struct Output {
        let countText: BehaviorRelay<String>
        let productsPrice: BehaviorRelay<String>
        let deliveryPrice: BehaviorRelay<String>
    }
}
