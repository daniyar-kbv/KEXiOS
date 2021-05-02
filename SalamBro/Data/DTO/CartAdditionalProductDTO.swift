//
//  CartAdditionalProduct.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import Foundation

public struct CartAdditionalProductDTO: Codable {
    let id: Int
    let name: String
    let price: Int
    var count: Int = 0
    let available: Bool
}

public extension CartAdditionalProductDTO {
    func toDomain() -> CartAdditionalProduct {
        .init(id: id,
              name: name,
              price: price,
              available: available)
    }

    init(from domain: CartAdditionalProduct) {
        id = domain.id
        name = domain.name
        price = domain.price
        available = domain.available
    }
}
