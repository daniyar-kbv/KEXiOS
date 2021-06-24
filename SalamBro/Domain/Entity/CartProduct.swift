//
//  Product.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import Foundation

// Tech debt: Legacy

public struct CartProduct {
    let id: Int
    let name: String
    let description: String?
    let price: Int
    var count: Int
    let commentary: String?
    let available: Bool
}

extension CartProduct: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
