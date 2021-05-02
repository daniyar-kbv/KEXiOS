//
//  Cart.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import Foundation

public struct CartDTO: Codable {
    let id: Int
    var totalProducts: Int
    var totalPrice: Int
    var products: [CartProductDTO]
    var productsAdditional: [CartAdditionalProductDTO]
}

public extension CartDTO {
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
        products = domain.products.map { CartProductDTO(from: $0) }
        productsAdditional = domain.productsAdditional.map { CartAdditionalProductDTO(from: $0) }
    }
}
