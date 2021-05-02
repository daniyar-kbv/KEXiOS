//
//  Ad.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation

public struct Ad {
    let name: String
}

extension Ad: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
