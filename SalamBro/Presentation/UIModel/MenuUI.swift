//
//  Menu.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct MenuUI {
    let foodTypes: [FoodTypeUI]
}

public extension MenuUI {
    func toDomain() -> Menu {
        .init(foodTypes: foodTypes.map { $0.toDomain() })
    }

    init(from domain: Menu) {
        foodTypes = domain.foodTypes.map { FoodTypeUI(from: $0) }
    }
}
