//
//  CartAdditionalProduct.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import Foundation

public struct CartAdditionalProduct: Decodable {
    let id: Int
    let name: String
    let price: Int
    var count: Int = 0
    let available: Bool
}
