//
//  PaymentSelectionView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentSelectionView: UIView {
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = SBLocalization.localized(key: PaymentSelectionText.paymentMethod)
        return label
    }()

    private let choosePaymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = SBLocalization.localized(key: PaymentSelectionText.choosePaymentMethod)
        return label
    }()

    private(set) var changeButton: UIButton = {
        let button = UIButton()
        button.setTitle(SBLocalization.localized(key: PaymentSelectionText.change), for: .normal)
        button.backgroundColor = .arcticWhite
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()

    init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentSelectionView {
    private func configure() {
        addSubview(paymentMethodLabel)
        paymentMethodLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(14)
        }

        addSubview(changeButton)
        changeButton.snp.makeConstraints {
            $0.top.equalTo(paymentMethodLabel.snp.bottom).offset(3)
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.equalTo(72)
            $0.height.equalTo(18)
        }

        addSubview(choosePaymentMethodLabel)
        choosePaymentMethodLabel.snp.makeConstraints {
            $0.top.equalTo(paymentMethodLabel.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(changeButton.snp.leading).offset(-16)
            $0.height.equalTo(20)
        }
    }
}
