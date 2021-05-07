//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

class SetNameController: UIViewController {
    fileprivate lazy var rootView = SetNameView(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func loadView() {
        view = rootView
    }
}

extension SetNameController: GetNameViewDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }

    func submit() {
        navigationController?.popToViewController(ofClass: MainTabController.self)
    }
}

extension SetNameController {
    private func configUI() {
        navigationItem.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
