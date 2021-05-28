//
//  City.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
}

extension City: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id || lhs.name == rhs.name
    }
}
