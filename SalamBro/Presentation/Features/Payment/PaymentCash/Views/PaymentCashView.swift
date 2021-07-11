//
//  PaymentCashView.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import UIKit

protocol PaymentCashViewDelegate {
    func onSubmit()
}

final class PaymentCashView: UIView {
    var delegate: PaymentCashViewDelegate?

    private lazy var topLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.textColor = .darkGray
        return view
    }()

    private lazy var textField: MapTextField = {
        let view = MapTextField()
        view.placeholder = SBLocalization.localized(key: Payment.PaymentCash.Field.placeholder)
        return view
    }()

    private lazy var submitButton: UIButton = {
        let view = UIButton()
        view.setTitle(SBLocalization.localized(key: Payment.PaymentCash.Button.noChange), for: .normal)
        view.addTarget(self, action: #selector(handleSubmitButtonAction), for: .touchUpInside)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .calmGray
        view.isEnabled = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        backgroundColor = .arcticWhite

        [topLabel, textField, submitButton].forEach { addSubview($0) }

        topLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(24)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        submitButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
    }
}

extension PaymentCashView {
    @objc private func handleSubmitButtonAction() {
        delegate?.onSubmit()
    }
}
