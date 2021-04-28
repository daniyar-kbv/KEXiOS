//
//  CartViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

class CartViewModel {
    
    private let cartRepository: CartRepository
    var cart: Cart
    
    init(cartRepository: CartRepository) {
        self.cartRepository = cartRepository
        self.cart = cartRepository.getCart()
    }
    
    
}
