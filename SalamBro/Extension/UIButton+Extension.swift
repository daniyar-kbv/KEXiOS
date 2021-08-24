//
//  UIButton+Extension.swift
//  SalamBro
//
//  Created by Dan on 8/24/21.
//

import Foundation
import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        clipsToBounds = true // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setBackgroundImage(colorImage, for: forState)
        }
    }
}
