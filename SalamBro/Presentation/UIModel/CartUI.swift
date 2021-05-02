//
//  Cart.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import Foundation

public struct CartUI {
    let id: Int
    var totalProducts: Int
    var totalPrice: Int
    var products: [CartProductUI]
    var productsAdditional: [CartAdditionalProductUI]
}

public extension CartUI {
    func toDomain() -> Cart {
        .init(id: id,
              totalProducts: totalProducts,
              totalPrice: totalPrice,
              products: products.map { $0.toDomain() },
              productsAdditional: productsAdditional.map { $0.toDomain() })
    }

    init(from domain: Cart) {
        id = domain.id
        totalProducts = domain.totalProducts
        totalPrice = domain.totalPrice
        products = domain.products.map { CartProductUI(from: $0) }
        productsAdditional = domain.productsAdditional.map { CartAdditionalProductUI(from: $0) }
    }
}
