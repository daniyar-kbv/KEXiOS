//
//  CartStorage.swift
//  SalamBro
//
//  Created by Dan on 6/23/21.
//

import Foundation

protocol CartStorage {
    var cartItems: [CartDTO.Item] { get set }
}

extension Storage: CartStorage {
    private enum Keys: String {
        case cartItems
    }

    var cartItems: [CartDTO.Item] {
        get { get(key: Keys.cartItems.rawValue) ?? [] }
        set { save(key: Keys.cartItems.rawValue, object: newValue) }
    }
}
