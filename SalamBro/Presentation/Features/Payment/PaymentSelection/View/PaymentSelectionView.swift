//
//  PaymentSelectionView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentSelectionView: UIButton {
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.paymentMethod)
        return label
    }()

    private let choosePaymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.choosePaymentMethod)
        return label
    }()

    private lazy var leftStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [paymentMethodLabel, choosePaymentMethodLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 3
        return view
    }()

    private var changeLabel: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.change)
        label.backgroundColor = .arcticWhite
        label.textColor = .kexRed
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leftStack, changeLabel])
        view.distribution = .
            return view
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
    func setPaymentMethod(text: String) {
        choosePaymentMethodLabel.text = text
        choosePaymentMethodLabel.textColor = .darkGray
    }
}

extension PaymentSelectionView {
    private func configure() {}
}
