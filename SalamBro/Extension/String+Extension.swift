//
//  String+Extension.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

public extension String {
    func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d{2})", with: "$1 ($2) $3 $4 $5", options: .regularExpression, range: nil)
    }
}
