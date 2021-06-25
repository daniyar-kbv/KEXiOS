//
//  AuthNumberView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import InputMask
import SnapKit
import UIKit

protocol AuthNumberViewDelegate: AnyObject {
    func countryCodeButtonTapped()
}

final class AuthNumberView: UIView {
    weak var delegate: AuthNumberViewDelegate?

    private let countryCodeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    private let chevronView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevron.bottom")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()

    private let numberField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 26)
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.Authorization.NumberField.Placeholder.title,
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .medium)]
        )
        return field
    }()

    init(delegate: AuthNumberViewDelegate, maskedDelegate: MaskedTextFieldDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        numberField.delegate = maskedDelegate
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthNumberView {
    func configureButtonTitle(with buttonTitle: String) {
        countryCodeButton.setTitle(buttonTitle, for: .normal)
    }

    func configureActions() {
        countryCodeButton.addTarget(self, action: #selector(handleCountryCodeButtonAction), for: .touchUpInside)
        chevronView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCountryCodeButtonAction)))
    }

    private func layoutUI() {
        [countryCodeButton, chevronView, numberField].forEach {
            addSubview($0)
        }

        countryCodeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.width.height.equalTo(32)
        }

        chevronView.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeButton)
            $0.left.equalTo(countryCodeButton.snp.right)
            $0.size.equalTo(24)
        }

        numberField.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeButton)
            $0.left.equalTo(chevronView.snp.right).offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(32)
        }
    }

    @objc private func handleCountryCodeButtonAction() {
        delegate?.countryCodeButtonTapped()
    }
}
