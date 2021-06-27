//
//  CartAdditionalProduct.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import Foundation

// Tech debt: Legacy

public struct CartAdditionalProduct {
    let id: Int
    let name: String
    let price: Int
    var count: Int = 0
    let available: Bool
}

extension CartAdditionalProduct: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
