//
//  UIBarButtonConfigurable.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 24.06.2021.
//

import UIKit

protocol UIBarButtonConfigurable: AnyObject {
    func setBackButton(completion: @escaping (() -> Void))
    func setCloseButton(completion: @escaping (() -> Void))
}

extension UIViewController: UIBarButtonConfigurable {
    func setBackButton(completion: @escaping (() -> Void)) {
        let backBarButtonItem = UISBBarButtonItem(image: Asset.chevronLeft.image, style: .plain) {
            completion()
        }
        backBarButtonItem.tintColor = .kexRed
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    func setCloseButton(completion: @escaping (() -> Void)) {
        let closeBarButtonItem = UISBBarButtonItem(title: "Cancel", style: .plain) {
            completion()
        }

        closeBarButtonItem.tintColor = .kexRed
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
}
