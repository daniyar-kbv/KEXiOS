//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit
import WebKit
class AgreementController: UIViewController {
    
    fileprivate lazy var rootView = AgreementView(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }
}

extension AgreementController {
    private func configUI() {
        navigationItem.title = L10n.Agreement.Navigation.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension AgreementController: WKUIDelegate {
    
}
