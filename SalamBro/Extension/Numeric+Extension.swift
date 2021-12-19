//
//  Numeric+Extension.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
