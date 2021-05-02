//
//  FoodType.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct FoodType {
    let title: String
    let position: Int
    let foods: [Food]
}

extension FoodType: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title
    }
}
