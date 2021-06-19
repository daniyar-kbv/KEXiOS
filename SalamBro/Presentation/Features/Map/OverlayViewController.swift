//
//  TestViewController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/19/21.
//

import SnapKit
import UIKit

protocol OverlaySheetDelegate: AnyObject {
    func passCommentary(text: String)
}

class OverlayViewController: UIViewController {
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .arcticWhite
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()

    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var commentTextField: UITextField = {
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

    private lazy var sendButton: UIButton = {
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

    weak var delegate: OverlaySheetDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        commentTextField.becomeFirstResponder()
    }
}

extension OverlayViewController {
    private func layoutUI() {
        view.backgroundColor = .green

        [contentView].forEach {
            view.addSubview($0)
        }

        [commentView, sendButton].forEach {
            contentView.addSubview($0)
        }
        commentView.addSubview(commentTextField)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

extension OverlayViewController {
    @objc private func sendPressed() {
        if let commentary = commentTextField.text {
            delegate?.passCommentary(text: commentary)
            dismiss(animated: true, completion: nil)
        }
    }
}
