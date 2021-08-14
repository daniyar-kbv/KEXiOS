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
    private var onChange: ((_ textField: UITextField, _ value: String, _ complete: Bool) -> Void)?

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
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        textColor = .darkGray
        font = .systemFont(ofSize: 16, weight: .medium)
        autocapitalizationType = .allCharacters
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        autocorrectionType = .no
        keyboardType = inputType.keyboardType
        delegate = inputType.needMask ? maskedDelegate : self
        textContentType = inputType.textContentType
    }

    func isComplete() -> Bool {
        return inputType.validate(text: text ?? "")
    }

    func setMaskedTextChangedCallback(_ callBack: @escaping (_ textField: UITextField, _ value: String, _ complete: Bool) -> Void) {
        if inputType.needMask {
            maskedDelegate.onMaskedTextChangedCallback = callBack
        } else {
            onChange = callBack
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentCardMaskedField: UITextFieldDelegate {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        onChange?(self, string, true)
        return true
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

        var needMask: Bool {
            switch self {
            case .cardNumber, .expiryDate, .CVV: return true
            case .cardhodlerName: return false
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .cardNumber, .expiryDate, .CVV: return .decimalPad
            case .cardhodlerName: return .asciiCapable
            }
        }

        var textContentType: UITextContentType? {
            switch self {
            case .cardNumber: return .creditCardNumber
            default: return nil
            }
        }

        func validate(text: String) -> Bool {
            switch self {
            case .cardNumber: return text.count == 19
            case .expiryDate: return text.count == 5
            case .CVV: return text.count == 3
            case .cardhodlerName: return text.count > 3 && text.contains(" ")
            }
        }
    }
}
