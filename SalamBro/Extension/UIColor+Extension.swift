//
//  UIColor+Extension.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

extension UIColor {
    static let kexRed = UIColor(red: 0.82, green: 0.216, blue: 0.192, alpha: 1)
    static let darkGray = UIColor(red: 51, green: 51, blue: 51)
    static let arcticWhite = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let mildBlue = UIColor(red: 165, green: 173, blue: 182)
    static let lightGray = UIColor(red: 242, green: 242, blue: 242)
    static let calmGray = UIColor(red: 0.827, green: 0.835, blue: 0.851, alpha: 1)
    static let darkRed = UIColor(red: 164, green: 56, blue: 52)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
