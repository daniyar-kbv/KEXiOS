//
//  CartStorage.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

protocol CartStorage {
    var cartItems: [CartItem] { get set }
}

extension Storage: CartStorage {
    private enum Keys: String {
        case cartItems
    }

    var cartItems: [CartItem] {
        get { get(key: Keys.cartItems.rawValue) ?? [] }
        set { save(key: Keys.cartItems.rawValue, object: newValue) }
    }
}
