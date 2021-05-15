//
//  Address.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

public struct Address {
    public var name: String
    public var longitude: Double
    public var latitude: Double
}

extension Address: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
