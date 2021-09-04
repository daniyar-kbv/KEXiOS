//
//  CartStorage.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

protocol CartStorage {
    var cart: Cart { get set }
    var additionalProducts: [AdditionalPosition] { get set }
}

extension Storage: CartStorage {
    private enum Keys: String {
        case cart
        case additionalProducts
    }

    var cart: Cart {
        get { get(key: Keys.cart.rawValue) ?? Cart(items: [], price: 0, positionsCount: 0, hasUnavailableProducts: false) }
        set { save(key: Keys.cart.rawValue, object: newValue) }
    }

    var additionalProducts: [AdditionalPosition] {
        get { get(key: Keys.additionalProducts.rawValue) ?? [] }
        set { save(key: Keys.additionalProducts.rawValue, object: newValue) }
    }
}
