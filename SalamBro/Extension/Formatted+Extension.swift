//
//  Formatted+Extension.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}
