//
//  Models.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Foundation

public struct FoodUI {
    let id: Int
    let title: String
    let price: Int
    let description: String
}

public extension FoodUI {
    func toDomain() -> Food {
        .init(id: id,
              title: title,
              price: price,
              description: description)
    }

    init(from domain: Food) {
        id = domain.id
        title = domain.title
        price = domain.price
        description = domain.description
    }
}
