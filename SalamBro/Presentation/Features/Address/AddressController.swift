//
//  AddressController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

import UIKit

class AddressController: UIViewController {

    fileprivate lazy var rootView = AddressView(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

//        rootView.contentView.bottomAnchor.constraint(equalTo: rootView.contentView.bottomAnchor).isActive = true
        var contentInset:UIEdgeInsets = rootView.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        rootView.scrollView.contentInset = contentInset
        
      }

     @objc func keyboardWillHide(notification: Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        rootView.scrollView.contentInset = contentInset
     }
}

extension AddressController {
    func submitForms() {
        print("proceed to next view")
        let vc = BrandsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddressController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("received scroll")
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
