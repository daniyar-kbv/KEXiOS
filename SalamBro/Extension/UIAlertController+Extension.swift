//
//  UIAlertController+EXtension.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

extension UIAlertController {
    public convenience init(attributedTitle: NSAttributedString?, attributedMessage: NSAttributedString?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction] = []) {
        self.init(title: nil, message: nil, preferredStyle: preferredStyle)

        self.setValue(attributedTitle, forKey: "attributedTitle")
        self.setValue(attributedMessage, forKey: "attributedMessage")
        self.view.tintColor = .kexRed
        for action in actions {
            self.addAction(action)
        }
    }
}
