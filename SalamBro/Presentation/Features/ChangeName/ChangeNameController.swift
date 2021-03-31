//
//  ChangeNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit



class ChangeNameController: UIViewController {

    fileprivate lazy var rootView = ChangeNameView(delegate: self)
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        navigationController?.title = "change name"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension ChangeNameController: ChangeNameViewDelegate {
    func saveName() {
        self.navigationController?.popViewController(animated: true)
    }
}
