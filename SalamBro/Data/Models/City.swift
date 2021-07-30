//
//  City.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 27.05.2021.
//

import Foundation

public struct City: Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

extension City: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id || lhs.name == rhs.name
    }
}
