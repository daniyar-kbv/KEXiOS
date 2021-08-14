//
//  PaymentSelectionView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import PassKit
import RxCocoa
import RxSwift
import UIKit

protocol PaymentSelectionContainerViewDelegate: AnyObject {
    func handleChangePaymentMethod()
    func handleSubmitButtonTap()
}

final class PaymentSelectionContainerView: UIView {
    private let disposeBag = DisposeBag()

    weak var delegate: PaymentSelectionContainerViewDelegate?

    private let paymentSelectionButton = PaymentSelectionButton()

    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle(SBLocalization.localized(key: PaymentText.PaymentSelection.orderPayment), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .calmGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    private lazy var applePayButton: PKPaymentButton = {
        let view = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()

    private let billTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.text = SBLocalization.localized(key: PaymentText.PaymentSelection.bill)
        label.textAlignment = .left
        return label
    }()

    private let billLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    init() {
        super.init(frame: .zero)
        configure()
        bindViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentSelectionContainerView {
    func setPaymentMethod(paymentMethod: PaymentMethod?) {
        paymentSelectionButton.setPaymentMethod(text: paymentMethod?.title,
                                                isApplePay: paymentMethod?.type == .applePay)
        configActionButton(with: paymentMethod)
    }

    func set(totalAmount: String?) {
        billLabel.text = totalAmount
    }
}

extension PaymentSelectionContainerView {
    private func bindViews() {
        actionButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.handleSubmitButtonTap()
            })
            .disposed(by: disposeBag)

        applePayButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.handleSubmitButtonTap()
            })
            .disposed(by: disposeBag)

        paymentSelectionButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.handleChangePaymentMethod()
            })
            .disposed(by: disposeBag)
    }

    private func configure() {
        backgroundColor = .white
        addSubview(paymentSelectionButton)
        paymentSelectionButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }

        addSubview(applePayButton)
        applePayButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }

        addSubview(billTitleLabel)
        billTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(actionButton.snp.top).offset(-16)
            $0.leading.equalToSuperview().offset(24)
        }

        addSubview(billLabel)
        billLabel.snp.makeConstraints {
            $0.bottom.equalTo(actionButton.snp.top).offset(-16)
            $0.trailing.equalToSuperview().offset(-24)
            $0.leading.equalTo(billTitleLabel.snp.trailing).offset(16)
        }
    }

    private func configActionButton(with paymentMethod: PaymentMethod?) {
        actionButton.backgroundColor = paymentMethod != nil ? .kexRed : .calmGray
        actionButton.isEnabled = paymentMethod != nil
        actionButton.isHidden = paymentMethod?.type == .applePay
        applePayButton.isHidden = paymentMethod?.type != .applePay
    }
}
