//
//  RateItem.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/28/21.
//

import Foundation

struct RateItem {
    var sample: RateSample
    var isSelected: Bool
}

extension RateItem: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.sample.id == rhs.sample.id
    }
}
