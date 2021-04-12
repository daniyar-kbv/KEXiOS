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
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//
//                let height = keyboardSize.height
//                self.rootView.saveButton.frame.origin.y += height
//
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//
//                let height = keyboardSize.height
//                rootView.saveButton.frame.origin.y -= height
//        }
//    }
}

extension ChangeNameController: ChangeNameViewDelegate {
    func saveName() {
        self.navigationController?.popViewController(animated: true)
    }
}
