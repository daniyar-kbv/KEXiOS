//
//  AlertDisplayable.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import UIKit

protocol AlertDisplayable: AnyObject {
    func showError(_ error: ErrorPresentable)
    func showError(_ error: ErrorPresentable, completion: @escaping () -> Void)
    func showAlert(title: String, message: String?, submitTitle: String, completion: @escaping () -> Void)
}

extension AlertDisplayable where Self: UIViewController {
    func showError(_ error: ErrorPresentable) {
        showAlert(title: "Ошибка", message: error.presentationDescription)
    }

    func showError(_ error: ErrorPresentable, completion: @escaping () -> Void) {
        showAlert(title: "Ошибка", message: error.presentationDescription, submitTitle: "Ок", completion: completion)
    }

    func showAlert(title: String, message: String?, submitTitle: String = "Oк", completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: submitTitle, style: .default) { _ in
            completion()
        }
        alertController.addAction(action)
        alertController.view.tintColor = UIColor.black

        present(alertController, animated: true, completion: nil)
    }
}
