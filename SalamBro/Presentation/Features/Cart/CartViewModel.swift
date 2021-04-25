//
//  CartViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

class CartViewModel {
    
    private let cartRepository: CartRepository
    
    init(cartRepository: CartRepository) {
        self.cartRepository = cartRepository
    }
}
