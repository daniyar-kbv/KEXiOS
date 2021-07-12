//
//  PaymentCardMaskedField.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import InputMask
import UIKit

final class PaymentCardMaskedField: UITextField, MaskedTextFieldDelegateListener {
    private let inputType: InputType

    private let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    private lazy var maskedDelegate: MaskedTextFieldDelegate = {
        let delegate = MaskedTextFieldDelegate(primaryFormat: inputType.maskFormat)
        delegate.listener = self
        return delegate
    }()

    init(inputType: InputType) {
        self.inputType = inputType

        super.init(frame: .zero)

        placeholder = inputType.placeholder
        delegate = maskedDelegate
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        textColor = .darkGray
        font = .systemFont(ofSize: 16, weight: .medium)
        autocapitalizationType = .allCharacters
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentCardMaskedField {
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension PaymentCardMaskedField {
    enum InputType {
        case cardNumber
        case expiryDate
        case CVV
        case cardhodlerName

        var placeholder: String {
            switch self {
            case .cardNumber: return SBLocalization.localized(key: PaymentText.PaymentCard.cardNumber)
            case .expiryDate: return SBLocalization.localized(key: PaymentText.PaymentCard.expiryDate)
            case .CVV: return "CVC/CVV"
            case .cardhodlerName: return SBLocalization.localized(key: PaymentText.PaymentCard.cardholderName)
            }
        }

        var maskFormat: String {
            switch self {
            case .cardNumber: return "[0000] [0000] [0000] [0000]"
            case .expiryDate: return "[00]{/}[00]"
            case .CVV: return "[000]"
            case .cardhodlerName: return ""
            }
        }
    }
}
