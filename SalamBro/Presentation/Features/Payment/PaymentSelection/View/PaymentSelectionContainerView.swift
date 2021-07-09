//
//  PaymentSelectionView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit

protocol PaymentSelectionContainerViewDelegate: AnyObject {
    func handleChangePaymentMethod()
}

final class PaymentSelectionContainerView: UIView {
    private let disposeBag = DisposeBag()

    weak var delegate: PaymentSelectionContainerViewDelegate?

    private let paymentSelectionView = PaymentSelectionView()
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle(SBLocalization.localized(key: Payment.PaymentSelectionText.orderPayment), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .calmGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    private let billTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.text = SBLocalization.localized(key: Payment.PaymentSelectionText.bill)
        label.textAlignment = .left
        return label
    }()

    private let billLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "2 870 ₸"
        label.textColor = .darkGray
        label.textAlignment = .right
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
    private func bindViews() {
        actionButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let _ = self else { return }
                debugPrint("action tapped")
            })
            .disposed(by: disposeBag)

        paymentSelectionView.changeButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.handleChangePaymentMethod()
            })
            .disposed(by: disposeBag)
    }

    private func configure() {
        backgroundColor = .white
        addSubview(paymentSelectionView)
        paymentSelectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }

        addSubview(billTitleLabel)
        billTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(actionButton.snp.top).offset(-16)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(88)
            $0.height.equalTo(21)
        }

        addSubview(billLabel)
        billLabel.snp.makeConstraints {
            $0.bottom.equalTo(actionButton.snp.top).offset(-16)
            $0.trailing.equalToSuperview().offset(-24)
            $0.leading.equalTo(billTitleLabel.snp.trailing).offset(16)
            $0.height.equalTo(21)
        }
    }
}
