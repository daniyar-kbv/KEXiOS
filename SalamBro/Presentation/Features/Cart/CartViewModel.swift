//
//  CartViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

class CartViewModel {
    var coordinator: CartCoordinator
    private let cartRepository: CartRepository
    var cart: Cart
    
    init(coordinator: CartCoordinator, cartRepository: CartRepository) {
        self.coordinator = coordinator
        self.cartRepository = cartRepository
        self.cart = cartRepository.getCart()
    }
    
}
