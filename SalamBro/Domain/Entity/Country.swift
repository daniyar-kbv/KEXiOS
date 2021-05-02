//
//  Country.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

public struct Country {
    let id: Int
    let name: String
    let callingCode: String
}

extension Country: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
