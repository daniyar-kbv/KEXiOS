//
//  ChangeNameView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/23/21.
//

import SnapKit
import UIKit

protocol ChangeNameViewDelegate: AnyObject {
    func textFieldsTapped(_ textfield: UITextField)
    func saveButtonTapped()
}

final class ChangeNameView: UIView {
    weak var delegate: ChangeNameViewDelegate?

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = L10n.ChangeName.nameLabel
        return view
    }()

    private lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private(set) lazy var nameTextField: UITextField = {
        let field = UITextField()
        return field
    }()

    private lazy var emailLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = L10n.ChangeName.emailLabel
        return view
    }()

    private lazy var emailView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private(set) lazy var emailTextField: UITextField = {
        let field = UITextField()
        return field
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.ChangeName.SaveButton.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .calmGray
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    init(delegate: ChangeNameViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        layoutUI()
        configureActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChangeNameView {
    private func configureActions() {
        nameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveName), for: .touchUpInside)
    }

    func configureTextFields(name: String, email: String) {
        nameTextField.text = name
        emailTextField.text = email
        saveButton.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }

    func configureButton(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.backgroundColor = isEnabled ? .kexRed : .calmGray
    }

    private func layoutUI() {
        backgroundColor = .arcticWhite
        nameView.addSubview(nameTextField)
        emailView.addSubview(emailTextField)
        [nameLabel, nameView, emailLabel, emailView, saveButton].forEach {
            addSubview($0)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalTo(nameView.snp.left).offset(16)
        }

        nameView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        nameTextField.snp.makeConstraints {
            $0.left.right.equalTo(nameView).inset(16)
            $0.centerY.equalTo(nameView.snp.centerY)
        }

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(24)
            $0.left.equalTo(emailView.snp.left).offset(16)
        }

        emailView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        emailTextField.snp.makeConstraints {
            $0.left.right.equalTo(emailView).inset(16)
            $0.centerY.equalTo(emailView.snp.centerY)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(emailView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
    }

    @objc private func editingChanged(sender: UITextField) {
        delegate?.textFieldsTapped(sender)
    }

    @objc private func saveName() {
        delegate?.saveButtonTapped()
    }
}
