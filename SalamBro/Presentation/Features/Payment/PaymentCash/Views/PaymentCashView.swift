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
    func textViewDidChange(text: String)
}

final class PaymentCashView: UIView {
    var delegate: PaymentCashViewDelegate?

    private lazy var topLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.textColor = .darkGray
        view.numberOfLines = 0
        return view
    }()

    private lazy var textField: MapTextField = {
        let view = MapTextField()
        view.placeholder = SBLocalization.localized(key: PaymentText.PaymentCash.Field.placeholder)
        view.onChange = fieldDidChange
        view.keyboardType = .decimalPad
        view.inputType = .decimal
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .kexRed
        view.font = .systemFont(ofSize: 10, weight: .medium)
        return view
    }()

    private lazy var submitButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(handleSubmitButtonAction), for: .touchUpInside)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
        configSubmitButton(isEnabled: true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        backgroundColor = .arcticWhite

        [topLabel, textField, descriptionLabel, submitButton].forEach { addSubview($0) }

        topLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(24)
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
        }

        submitButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
    }
}

extension PaymentCashView {
    func set(price: String) {
        topLabel.text = SBLocalization.localized(key: PaymentText.PaymentCash.topText, arguments: price)
    }

    func set(needChange: Bool) {
        submitButton.setTitle(
            needChange ?
                SBLocalization.localized(key: PaymentText.PaymentCash.Button.submit) :
                SBLocalization.localized(key: PaymentText.PaymentCash.Button.noChange),
            for: .normal
        )
    }

    func set(isChangeLess: Bool) {
        performError(action: isChangeLess ? .show(.changeLess) : .hide)
    }
}

extension PaymentCashView {
    private func performError(action: ErrorAction) {
        switch action {
        case let .show(error):
            descriptionLabel.text = error.description
        case .hide:
            descriptionLabel.text = ""
        }
        configSubmitButton(isEnabled: action.needEnable)
        configTextField(isEnabled: action.needEnable)
    }

    private func configTextField(isEnabled: Bool) {
        textField.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor.kexRed.cgColor
        textField.layer.borderWidth = isEnabled ? 0 : 1
    }

    private func configSubmitButton(isEnabled: Bool) {
        submitButton.backgroundColor = isEnabled ? .kexRed : .calmGray
        submitButton.isUserInteractionEnabled = isEnabled
    }
}

extension PaymentCashView {
    private func fieldDidChange() {
        delegate?.textViewDidChange(text: textField.text)
    }

    @objc private func handleSubmitButtonAction() {
        delegate?.onSubmit()
    }
}

extension PaymentCashView {
    private enum ErrorAction {
        case show(Error)
        case hide

        var needEnable: Bool {
            switch self {
            case .show: return false
            case .hide: return true
            }
        }
    }

    private enum Error {
        case changeLess

        var description: String {
            switch self {
            case .changeLess:
                return SBLocalization.localized(key: PaymentText.PaymentCash.Field.description)
            }
        }
    }
}
