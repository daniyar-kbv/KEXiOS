//
//  CartStorage.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

protocol CartStorage {
    var cart: Cart { get set }
}

extension Storage: CartStorage {
    private enum Keys: String {
        case cart
    }

    var cart: Cart {
        get { get(key: Keys.cart.rawValue) ?? Cart(items: [], price: 0, positionsCount: 0) }
        set { save(key: Keys.cart.rawValue, object: newValue) }
    }
}
