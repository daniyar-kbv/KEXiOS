//
//  PaymentSelectionView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentSelectionButton: UIButton {
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.paymentMethod)
        return label
    }()

    private lazy var applePayImage: UIImageView = {
        let view = UIImageView()
        view.image = SBImageResource.getIcon(for: PaymentIcons.PaymentMethod.applePay)
        view.isHidden = true
        return view
    }()

    private let choosePaymentMethodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mildBlue
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.choosePaymentMethod)
        return label
    }()

    private lazy var leftBottomStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [applePayImage, choosePaymentMethodLabel])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 10
        return view
    }()

    private lazy var leftStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [paymentMethodLabel, leftBottomStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 3
        view.isUserInteractionEnabled = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private var changeLabel: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.change)
        label.backgroundColor = .arcticWhite
        label.textColor = .kexRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.isUserInteractionEnabled = false
        return label
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

extension PaymentSelectionButton {
    func setPaymentMethod(text: String?, isApplePay: Bool) {
        choosePaymentMethodLabel.text = text != nil ?
            text :
            SBLocalization.localized(key: PaymentText.PaymentSelection.choosePaymentMethod)
        choosePaymentMethodLabel.textColor = text != nil ? .darkGray : .mildBlue
        applePayImage.isHidden = !isApplePay
    }
}

extension PaymentSelectionButton {
    private func configure() {
        [changeLabel, leftStack].forEach { addSubview($0) }

        applePayImage.snp.makeConstraints {
            $0.size.equalTo(30)
        }

        changeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
        }

        leftStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(changeLabel.snp.left)
        }
    }
}
