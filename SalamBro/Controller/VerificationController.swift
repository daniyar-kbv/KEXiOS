//
//  VerificationViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/9/21.
//

import UIKit

class VerificationController: UIViewController {
    
    fileprivate lazy var rootView = VerificationView(delegate: self)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootView.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        rootView.pinCodeTextField.text = ""
        rootView.pinCodeTextField.clearLabels()
        rootView.timer.invalidate()
        rootView.getCodeButton.setTitle("Отправить повторно через: 01:30", for: .disabled)
    }
}

extension VerificationController: VerificationViewDelegate {
    func passCode() {
        let vc = GetNameController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
