//
//  CartRepositoryImplementation.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

class CartRepositoryIml: CartRepository {
    
    private let api: APIService
    
    init(api: APIService) {
        self.api = api
    }
    
    func getCartProducts() -> [CartProduct] {
        return []
    }
    
    func getCartAdditionalProducts() -> [CartAdditionalProduct] {
        return []
    }
    
    func getCart() -> Cart {
        return Cart(id: 0, totalProducts: 0, totalPrice: 0, products: [], productsAdditional: [])
    }
}
