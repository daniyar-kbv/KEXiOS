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
    func checkForViewHeight() {
        if view.frame.height <= 568 {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowForAuth), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideForAuth), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShowForAuth(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIApplication.shared.keyWindow?.frame.origin.y -= keyboardSize.height / 3
        }
    }

    @objc func keyboardWillHideForAuth(notification _: NSNotification) {
        UIApplication.shared.keyWindow?.frame.origin.y = 0.0
    }
}
