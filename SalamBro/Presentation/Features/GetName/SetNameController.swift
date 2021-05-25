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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
//        navigationItem.backButtonTitle = ""
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
