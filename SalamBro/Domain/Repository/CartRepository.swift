//
//  CartRepository.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import Foundation

protocol CartRepository {
    func getCartProducts() -> [CartProduct]
    func getCartAdditionalProducts()  -> [CartAdditionalProduct]
    func getCart() -> Cart
}
