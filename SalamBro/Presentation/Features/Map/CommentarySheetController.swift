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

    public var isPromocode = false
    public var isCommentary = false

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
            if isPromocode {
                if getScreenSize() == 40 {
                    view.frame.origin.y -= keyboardSize.height - 63
                } else {
                    view.frame.origin.y -= keyboardSize.height - 49
                }
            }

            if isCommentary {
                view.frame.origin.y = yCoordinate + 20
                if getScreenSize() == 40 {
                    view.frame.origin.y -= keyboardSize.height - 65
                } else {
                    view.frame.origin.y -= keyboardSize.height - 55
                }
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        if isPromocode {
            view.frame.origin.y = getScreenSize() == 40 ? yCoordinate! - 5 : yCoordinate!
        }

        if isCommentary {
            view.frame.origin.y = getScreenSize() == 40 ? yCoordinate! + 75 : yCoordinate! + 55
        }
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
        isPromocode = false
        isCommentary = false
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

        let indent: CGFloat = height <= 736 ? 0 : 40

        return indent
    }
}
