//
//  RateItem.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/28/21.
//

import Foundation

struct RateItem: Codable {
    var title: String
    var isSelected: Bool
}

extension RateItem: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.title == rhs.title || lhs.isSelected == rhs.isSelected
    }
}
