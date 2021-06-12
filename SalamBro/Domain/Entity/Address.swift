//
//  Address.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation

//  Tech debt: leave only Address or MapAddress

public struct Address: Codable {
    public var name: String
    public var longitude: Double
    public var latitude: Double
    public var commentary: String?
}

extension Address: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
