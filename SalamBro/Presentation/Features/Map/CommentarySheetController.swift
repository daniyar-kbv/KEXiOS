//
//  CommentarySheetController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/17/21.
//

import SnapKit
import UIKit

protocol CommentarySheetDelegate: AnyObject {
    func showCommentarySheet()
    func passCommentary(text: String)
    func addShadow(toggle: Bool)
    func hideCommentarySheet()
}

final class CommentarySheetController: UIViewController {
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .arcticWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()

    private var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    public var commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(
            string: L10n.Commentary.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        textfield.borderStyle = .none
        textfield.clearButtonMode = .never
        textfield.minimumFontSize = 17
        textfield.adjustsFontSizeToFitWidth = true
        textfield.contentHorizontalAlignment = .left
        textfield.contentVerticalAlignment = .center
        return textfield
    }()

    public var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Commentary.Button.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .kexRed
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.cornerRadius = 10
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.adjustsImageWhenHighlighted = true
        button.adjustsImageWhenDisabled = true
        button.addTarget(self, action: #selector(sendPressed), for: .allTouchEvents)
        return button
    }()

    private lazy var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
//        view.isHidden = true
        return view
    }()

    weak var delegate: CommentarySheetDelegate?

    private var yCoordinate: CGFloat!

    // MARK: Tech Debt - Change logic by creating a new class for view presentation

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTextField), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(beginEdit), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        yCoordinate = view.frame.origin.y
        beginEdit()
        //   delegate?.addShadow(toggle: true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        // delegate?.addShadow(toggle: false)
    }
}

extension CommentarySheetController {
    private func layoutUI() {
        view.backgroundColor = .clear
        // navigationController?.setNavigationBarHidden(true, animated: true)

        [contentView].forEach {
            view.addSubview($0)
        }

        [commentView, sendButton].forEach {
            contentView.addSubview($0)
        }
        commentView.addSubview(commentTextField)

        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(14)
        }

        commentView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
        }

        sendButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(commentView.snp.bottom).offset(16)
            $0.height.equalTo(43)
        }

        commentTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }
    }
}

extension CommentarySheetController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y = yCoordinate + 20
            if getScreenSize() == 40 {
                view.frame.origin.y -= keyboardSize.height - 65
            } else {
                view.frame.origin.y -= keyboardSize.height - 55
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        dismissSheet()
    }

    @objc func sendPressed() {
//        if let commentary = commentTextField.text {
//            // FIXME: - self.dissmiss not working in ios 11, need further investigation
//            //            self.dismiss(animated: true) {
//            dismissSheet()
//            delegate?.passCommentary(text: commentary)
//            //            }
//        }
    }

    private func dismissSheet() {
//        view.removeFromSuperview()
        // delegate?.hideCommentarySheet()
    }

    @objc func hideTextField() {
        commentTextField.endEditing(true)
    }

    @objc func beginEdit() {
        commentTextField.becomeFirstResponder()
    }

    private func getScreenSize() -> CGFloat {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        let indent: CGFloat = height <= 736 ? 0 : 40

        return indent
    }
}
