//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

class SetNameController: ViewController {
    fileprivate lazy var rootView = SetNameView(delegate: self)

    override func loadView() {
        view = rootView
    }
}

extension SetNameController: GetNameViewDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }

    func submit() {
        navigationController?.popToRootViewController(animated: true)
    }
}
