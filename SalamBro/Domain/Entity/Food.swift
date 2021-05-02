//
//  Models.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import Foundation

public struct Food {
    let id: Int
    let title: String
    let price: Int
    let description: String
}

extension Food: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
