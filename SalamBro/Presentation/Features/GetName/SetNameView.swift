//
//  GetNameView.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import SnapKit
import UIKit

protocol GetNameViewDelegate: AnyObject {
    func submit(name: String)
}

final class SetNameView: UIView {
    weak var delegate: GetNameViewDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.GetName.title
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.GetName.Field.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var nextButton: UIButton = {
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
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetNameView {
    private func layoutUI() {
        backgroundColor = .arcticWhite

        nameView.addSubview(nameField)
        [titleLabel, nextButton, nameView].forEach {
            addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(safeAreaLayoutGuide.snp.left).offset(24)
            $0.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-24)
        }

        nameField.snp.makeConstraints {
            $0.left.equalTo(nameView.snp.left).offset(16)
            $0.right.equalTo(nameView.snp.right).offset(-16)
            $0.centerY.equalTo(nameView.snp.centerY)
        }

        nameView.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.left.equalTo(safeAreaLayoutGuide.snp.left).offset(24)
            $0.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-24)
        }

        nextButton.snp.makeConstraints {
            $0.height.equalTo(43)
            $0.top.equalTo(nameView.snp.bottom).offset(150)
            $0.left.equalTo(safeAreaLayoutGuide.snp.left).offset(24)
            $0.right.equalTo(safeAreaLayoutGuide.snp.right).offset(-24)
        }
    }

    @objc private func editingChanged(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard let name = nameField.text, !name.isEmpty else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .calmGray
            return
        }
        nextButton.isEnabled = true
        nextButton.backgroundColor = .kexRed
    }

    @objc private func submitAction() {
        guard let name = nameField.text else { return }
        delegate?.submit(name: name)
    }
}
