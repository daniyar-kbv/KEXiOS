//
//  UIBarButtonConfigurable.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import UIKit

protocol UIBarButtonConfigurable: AnyObject {
    func setBackButton(completion: @escaping (() -> Void))
}

extension UIViewController: UIBarButtonConfigurable {
    func setBackButton(completion: @escaping (() -> Void)) {
        let backBarButtonItem = UISBBarButtonItem(image: Asset.chevronLeft.image, style: .plain) {
            completion()
        }
        backBarButtonItem.tintColor = .kexRed
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
}
