//
//  CommentarySheetController.swift
//  yandex-map
//
//  Created by Arystan on 4/10/21.
//

import UIKit

class CommentarySheetController: UIViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var commentaryField: UITextField!
    @IBOutlet var proceedButton: UIButton!

    var delegate: MapDelegate?
    var yCoordinate: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTextField), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginEdit), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        yCoordinate = view.frame.origin.y
        beginEdit()
        delegate?.mapShadow(toggle: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        delegate?.mapShadow(toggle: false)
    }

    func setupViews() {
        commentaryField.placeholder = L10n.Commentary.AddressField.title
        proceedButton.setTitle(L10n.Commentary.Button.title, for: .normal)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        view.frame.origin.y = yCoordinate!
    }

    @IBAction func buttonAction(_: UIButton) {
        if commentaryField.text != nil {
            // FIXME: - self.dissmiss not working in ios 11, need further investigation
//            self.dismiss(animated: true) {
            removeFromParent()
            view.removeFromSuperview()
            delegate?.passCommentary(text: commentaryField.text!)
            delegate?.hideCommentarySheet()
//            }
        }
    }

    @objc func hideTextField() {
        commentaryField.endEditing(true)
    }

    @objc func beginEdit() {
        commentaryField.becomeFirstResponder()
    }
}
