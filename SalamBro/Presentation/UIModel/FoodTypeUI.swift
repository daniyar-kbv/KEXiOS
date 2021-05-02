//
//  FoodType.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct FoodTypeUI {
    let title: String
    let position: Int
    let foods: [FoodUI]
}

public extension FoodTypeUI {
    func toDomain() -> FoodType {
        .init(title: title,
              position: position,
              foods: foods.map { $0.toDomain() })
    }

    init(from domain: FoodType) {
        title = domain.title
        position = domain.position
        foods = domain.foods.map { FoodUI(from: $0) }
    }
}
