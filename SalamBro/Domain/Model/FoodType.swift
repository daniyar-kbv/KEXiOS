//
//  FoodType.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct FoodType: Decodable {
    let title:              String
    let position:           Int
    let foods:              [Food]
}
