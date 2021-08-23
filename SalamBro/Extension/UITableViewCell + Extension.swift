//
//  UITableViewCell + Extension.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/23/21.
//

import UIKit

extension UITableViewCell {
    func configureSelectedCellBackground() {
        let selectionBackground = UIView()
        selectionBackground.backgroundColor = .lightGray
        selectedBackgroundView = selectionBackground
    }
}
