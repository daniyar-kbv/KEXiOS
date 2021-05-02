//
//  Menu.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct MenuDTO: Decodable {
    let foodTypes: [FoodTypeDTO]
}

public extension MenuDTO {
    func toDomain() -> Menu {
        .init(foodTypes: foodTypes.map { $0.toDomain() })
    }

    init(from domain: Menu) {
        foodTypes = domain.foodTypes.map { FoodTypeDTO(from: $0) }
    }
}
