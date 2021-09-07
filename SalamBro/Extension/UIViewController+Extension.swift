//
//  UIViewController+Extension.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func addObserversForAuthFlow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowForAuthFlow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForAuthFlow), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeObserversForAuthFlow() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShowForAuthFlow(notification _: NSNotification) {}

    @objc func keyboardWillHideForAuthFlow(notification _: NSNotification) {}
}
