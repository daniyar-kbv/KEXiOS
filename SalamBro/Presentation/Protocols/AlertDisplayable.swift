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
    func showAlert(title: String, message: String?, actions: [UIAlertAction])
}

//  Tech debt: localize
extension AlertDisplayable where Self: UIViewController {
    func showError(_ error: ErrorPresentable) {
        //  Tech debt: localize
        showAlert(title: "Ошибка", message: error.presentationDescription)
    }

    func showError(_ error: ErrorPresentable, completion: @escaping () -> Void) {
        //  Tech debt: localize
        showAlert(title: "Ошибка", message: error.presentationDescription, submitTitle: "Ок", completion: completion)
    }

    //  Tech debt: localize
    func showAlert(title: String, message: String?, submitTitle: String = "Oк", completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: submitTitle, style: .default) { _ in
            completion()
        }
        alertController.addAction(action)

        configure(alertController: alertController)

        present(alertController, animated: true, completion: nil)
    }

    func showAlert(title: String, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        actions.forEach { alertController.addAction($0) }

        configure(alertController: alertController)

        present(alertController, animated: true, completion: nil)
    }

    private func configure(alertController: UIAlertController) {
        alertController.actions.forEach {
            $0.setValue(UIColor.kexRed, forKey: "titleTextColor")
        }
    }
}
