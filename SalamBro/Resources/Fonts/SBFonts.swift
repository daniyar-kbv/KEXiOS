//
//  SBFonts.swift
//  SalamBro
//
//  Created by Dan on 8/25/21.
//

import Foundation
import UIKit

protocol UIFontGetable {
    var name: String { get }
}

enum SBFonts: UIFontGetable {
    enum Pattaya: String, UIFontGetable {
        case regular = "Pattaya-Regular"

        var name: String { rawValue }
    }

    var name: String { "" }
}

enum SBFontResource {
    static func getFont(for font: UIFontGetable, with size: CGFloat) -> UIFont? {
        return UIFont(name: font.name, size: size)
    }
}
