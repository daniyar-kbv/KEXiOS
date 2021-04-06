//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

class GetNameController: UIViewController {

    fileprivate lazy var rootView = GetNameView(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }

}

extension GetNameController {
    func submitForms() {
        self.navigationController?.pushViewController(MainTabController(), animated: true)
    }
}

extension GetNameController: GetNameViewDelegate {
    func submit() {
        submitForms()
    }
}


extension GetNameController {
    private func configUI() {
        navigationItem.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

