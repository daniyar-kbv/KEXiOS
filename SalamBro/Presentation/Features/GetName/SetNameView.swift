//
//  GetNameView.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

protocol GetNameViewDelegate: AnyObject {
    func submit(name: String)
}

final class SetNameView: UIView {
    public var delegate: GetNameViewDelegate?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.GetName.title
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var nameField: UITextField = {
        let field = UITextField()
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.placeholder = L10n.GetName.Field.title
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.GetName.Button.title, for: .normal)
        button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        button.backgroundColor = .calmGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(delegate: GetNameViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetNameView {
    func setupViews() {
        backgroundColor = .arcticWhite
        addSubview(titleLabel)
        addSubview(nextButton)
        nameView.addSubview(nameField)
        addSubview(nameView)
    }

    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        nameField.leftAnchor.constraint(equalTo: nameView.leftAnchor, constant: 16).isActive = true
        nameField.rightAnchor.constraint(equalTo: nameView.rightAnchor, constant: -16).isActive = true
        nameField.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true

        nameView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        nameView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nameView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        nextButton.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 150).isActive = true
        nextButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nextButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }

    @objc func editingChanged(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard let name = nameField.text, !name.isEmpty else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .calmGray
            return
        }
        nextButton.isEnabled = true
        nextButton.backgroundColor = .kexRed
    }

    @objc func submitAction() {
        guard let name = nameField.text else { return }
        delegate?.submit(name: name)
    }
}
