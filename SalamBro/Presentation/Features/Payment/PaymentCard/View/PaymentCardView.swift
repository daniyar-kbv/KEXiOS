//
//  PaymentCardView.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol PaymentCardViewDelegate: AnyObject {
    func onSaveTap()
}

final class PaymentCardView: UIView {
    weak var delegate: PaymentCardViewDelegate?

    private let disposeBag = DisposeBag()

    private lazy var cardNumberField = PaymentCardMaskedField(inputType: .cardNumber)
    private lazy var expiryDateField = PaymentCardMaskedField(inputType: .expiryDate)
    private lazy var cvvCodeField = PaymentCardMaskedField(inputType: .CVV)
    private lazy var cardholderNameField = PaymentCardMaskedField(inputType: .cardhodlerName)

    private lazy var fields = [cardNumberField, expiryDateField, cvvCodeField, cardholderNameField]

    private lazy var middleStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [expiryDateField, cvvCodeField])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 13
        return view
    }()

    private lazy var cardStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cardNumberField, middleStackView, cardholderNameField])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 13
        return view
    }()

    private lazy var switchButton: UISwitch = {
        let view = UISwitch()
        return view
    }()

    private lazy var saveCardLabel: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.text = SBLocalization.localized(key: PaymentText.PaymentCard.saveCard)
        return view
    }()

    private lazy var saveButton: SBSubmitButton = {
        let view = SBSubmitButton(style: .filledRed)
        view.setTitle(SBLocalization.localized(key: PaymentText.PaymentCard.saveButton), for: .normal)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        saveButton.isEnabled = false
        layoutUI()
        configActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        cardNumberField.text = "4000 0566 5566 5556"
        expiryDateField.text = "11/23"
        cvvCodeField.text = "222"
        cardholderNameField.text = "TEST TEST"
        saveButton.isEnabled = true
        switchButton.isOn = true

        backgroundColor = .arcticWhite

        [cardStackView, switchButton, saveCardLabel, saveButton].forEach { addSubview($0) }

        cardStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }

        cardStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        }

        switchButton.snp.makeConstraints {
            $0.top.equalTo(cardStackView.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-24)
            $0.width.equalTo(52)
            $0.height.equalTo(32)
        }

        saveCardLabel.snp.makeConstraints {
            $0.centerY.equalTo(switchButton)
            $0.left.equalToSuperview().offset(24)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(switchButton.snp.bottom).offset(48)
            $0.height.equalTo(43)
            $0.left.right.equalToSuperview().inset(24)
        }
    }

    private func checkFields() {
        configInvalidFields(false)
        saveButton.isEnabled = !fields.map { $0.isComplete() }.contains(false)
    }

    private func configActions() {
        fields.forEach { field in
            field.setMaskedTextChangedCallback { [weak self] _, _, _ in
                self?.checkFields()
            }
        }

        saveButton
            .rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.onSaveTap()
            }).disposed(by: disposeBag)
    }

    private func configInvalidFields(_ isInvalid: Bool) {
        cardNumberField.layer.borderColor = isInvalid ? UIColor.kexRed.cgColor : UIColor.clear.cgColor
        expiryDateField.layer.borderColor = isInvalid ? UIColor.kexRed.cgColor : UIColor.clear.cgColor
        cvvCodeField.layer.borderColor = isInvalid ? UIColor.kexRed.cgColor : UIColor.clear.cgColor
    }

    func getCardNumber() -> String? {
        return cardNumberField.text
    }

    func getExpieryDate() -> String? {
        return expiryDateField.text
    }

    func getCVV() -> String? {
        return cvvCodeField.text
    }

    func getCardholderName() -> String? {
        return cardholderNameField.text
    }

    func getNeedsSave() -> Bool {
        return switchButton.isOn
    }

    func showInvalidFields() {
        configInvalidFields(true)
    }

    func showKeyboard() {
        cardNumberField.becomeFirstResponder()
    }
}
