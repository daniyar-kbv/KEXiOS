//
//  Models.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Foundation

struct Menu: Decodable {
    let foodTypes:          [FoodType]
}

struct FoodType: Decodable {
    let title:              String
    let position:           Int
    let foods:              [Food]
}

struct Food: Decodable {
    let id:                 Int
    let title:              String
    let price:              Int
//    let logo:               URL?
    let position:           Int
}
