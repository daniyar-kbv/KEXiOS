//
//  ChangeNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit

class ChangeNameController: UIViewController {
    fileprivate lazy var rootView = ChangeNameView(delegate: self)
    var yCoordinate: CGFloat?
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

    func setupUI() {
        yCoordinate = rootView.saveButton.frame.origin.y
        parent?.navigationController?.title = L10n.ChangeName.NavigationBar.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension ChangeNameController: ChangeNameViewDelegate {
    func saveName() {
        self.navigationController?.popViewController(animated: true)
    }
}
