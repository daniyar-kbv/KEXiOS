//
//  CommentarySheetController.swift
//  yandex-map
//
//  Created by Arystan on 4/10/21.
//

import UIKit

class CommentarySheetController: ViewController {
    @IBOutlet var contentView: UIView!
    @IBOutlet var commentaryField: UITextField!
    @IBOutlet var proceedButton: UIButton!

    weak var delegate: MapDelegate?
    private var yCoordinate: CGFloat!

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
        yCoordinate = view.frame.origin.y - 49
        beginEdit()
        delegate?.mapShadow(toggle: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        delegate?.mapShadow(toggle: false)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setupViews() {
        commentaryField.attributedPlaceholder = NSAttributedString(
            string: L10n.Commentary.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        proceedButton.setTitle(L10n.Commentary.Button.title, for: .normal)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 18
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if getScreenSize() == 40 {
                view.frame.origin.y -= keyboardSize.height / getScreenSize()
            } else {
                view.frame.origin.y -= keyboardSize.height
            }
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

    private func getScreenSize() -> CGFloat {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        var indent: CGFloat?

        switch height {
        case 568.0, 667.0, 736.0:
            indent = 0
        case 780.0, 812.0, 844.0, 896.0, 926.0:
            indent = 40
        default:
            print("Not listed in function")
        }
        return indent ?? 0
    }
}
