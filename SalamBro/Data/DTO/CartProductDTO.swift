//
//  Product.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import Foundation

public struct CartProductDTO: Decodable {
    let id: Int
    let name: String
    let description: String?
    let price: Int
    var count: Int
    let commentary: String?
    let available: Bool
}

public extension CartProductDTO {
    func toDomain() -> CartProduct {
        .init(id: id,
              name: name,
              description: description,
              price: price,
              count: count,
              commentary: commentary,
              available: available)
    }

    init(from domain: CartProduct) {
        id = domain.id
        name = domain.name
        description = domain.description
        price = domain.price
        count = domain.count
        commentary = domain.commentary
        available = domain.available
    }
}
