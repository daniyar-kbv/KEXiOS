//
//  VerificationViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/9/21.
//

import UIKit

class VerificationController: UIViewController {
    var number: String = ""
    fileprivate lazy var rootView = VerificationView(delegate: self, number: number)

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func loadView() {
        view = rootView
    }

    override func viewWillAppear(_: Bool) {
        rootView.startTimer()
    }

    override func viewDidDisappear(_: Bool) {
        rootView.otpField.text = ""
        rootView.otpField.clearLabels()
        rootView.timer.invalidate()
        rootView.getCodeButton.setTitle(L10n.Verification.Button.title(" 01:30"), for: .disabled)
    }
}

extension VerificationController: VerificationViewDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }

    func passCode() {
        let vc = GetNameController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VerificationController {
    private func configUI() {
        navigationItem.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
