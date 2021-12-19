//
//  UIAlertController+EXtension.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

public extension UIAlertController {
    convenience init(attributedTitle: NSAttributedString?, attributedMessage: NSAttributedString?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction] = []) {
        self.init(title: nil, message: nil, preferredStyle: preferredStyle)

        setValue(attributedTitle, forKey: "attributedTitle")
        setValue(attributedMessage, forKey: "attributedMessage")
        view.tintColor = .kexRed
        for action in actions {
            addAction(action)
        }
    }
}
