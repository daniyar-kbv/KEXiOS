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
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configUI()
    }
    
    override func loadView() {
        view = rootView
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            rootView.scrollView.contentInset = .zero
        } else {
            rootView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        rootView.scrollView.scrollIndicatorInsets = rootView.scrollView.contentInset
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
