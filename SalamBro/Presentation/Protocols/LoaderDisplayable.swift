//
//  LoaderDisplayable.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 30.05.2021.
//

import SVProgressHUD
import UIKit

protocol LoaderDisplayable: AnyObject {
    func showLoader()
    func hideLoader()
}

extension LoaderDisplayable where Self: UIViewController {
    func showLoader() {
        showLoader(animated: true, completion: { _ in })
    }

    func hideLoader() {
        hideLoader(animated: true, completion: { _ in })
    }

    private func showLoader(animated _: Bool, completion _: ((Bool) -> Void)? = nil) {
        view.endEditing(true)
        SVProgressHUD.show()
    }

    private func hideLoader(animated _: Bool, completion _: ((Bool) -> Void)? = nil) {
        SVProgressHUD.dismiss()
    }
}
