//
//  Cart.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import Foundation

public struct Cart {
    let id: Int
    var totalProducts: Int
    var totalPrice: Int
    var products: [CartProduct]
    var productsAdditional: [CartAdditionalProduct]
}
