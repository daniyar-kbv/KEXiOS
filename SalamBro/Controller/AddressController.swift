//
//  AddressController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class AddressController: UIViewController {

    fileprivate lazy var rootView = AddressView(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }

}

extension AddressController {
    func submitForms() {
        print("proceed to next view")
//        let vc = BrandController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddressController: AddressViewDelegate {
    func submit() {
        submitForms()
    }
}


extension AddressController {
    private func configUI() {
        navigationItem.title = "Set your delivery address"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
