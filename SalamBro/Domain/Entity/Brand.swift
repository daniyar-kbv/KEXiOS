//
//  Brand.swift
//  SalamBro
//
//  Created by Arystan on 4/7/21.
//

import Foundation

public struct Brand {
    public let id: Int
    public var name: String
    public let priority: Int
}

extension Brand: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
