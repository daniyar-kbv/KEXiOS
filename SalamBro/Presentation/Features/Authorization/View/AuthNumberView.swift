//
//  AuthNumberView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import SnapKit
import UIKit

final class AuthNumberView: UIView {
    let countryCodeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        return button
    }()

    let chevronView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevron.bottom")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()

    let numberField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 26)
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.Authorization.NumberField.Placeholder.title,
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .medium)]
        )
        return field
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthNumberView {
    private func layoutUI() {
        [countryCodeButton, chevronView, numberField].forEach {
            addSubview($0)
        }

        countryCodeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(32)
        }

        chevronView.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeButton)
            $0.leading.equalTo(countryCodeButton.snp.trailing)
            $0.size.equalTo(24)
        }

        numberField.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeButton)
            $0.leading.equalTo(chevronView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
}
