//
//  Double+Extension.swift
//  SalamBro
//
//  Created by Dan on 6/17/21.
//

import Foundation

extension Double {
    func rounded(to decimalPlaces: Int) -> Double {
        let decimalPlaces = 8
        let multiplier = NSDecimalNumber(decimal: pow(10, decimalPlaces)).doubleValue
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func removeTrailingZeros() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        return String(formatter.string(from: number) ?? "")
    }
}
