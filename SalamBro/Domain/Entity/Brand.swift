//
//  Brand.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Foundation

struct Brand: Codable {
    let id: Int
    let name: String
    let image: String
    let isAvailable: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case isAvailable = "is_available"
    }
}

extension Brand: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
