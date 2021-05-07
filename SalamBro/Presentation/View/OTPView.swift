//
//  OneTimeCodeView.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

class OTPView: UITextField {
    var didEnterLastDigit: ((String) -> Void)?

    private var isConfigured = false
    private var labels = [UILabel]()

    var defaultChar = "0"

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()

    func setup(with cellCount: Int = 4) {
        guard isConfigured == false else { return }
        isConfigured.toggle()

        setupTextField()

        let labelsView = createLabels(with: cellCount)
        addSubview(labelsView)
        addGestureRecognizer(tapRecognizer)

        labelsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelsView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setupTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad

        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }

        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }

    private func createLabels(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 22

        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.backgroundColor = .lightGray
            label.isUserInteractionEnabled = true
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            label.text = defaultChar
            label.textColor = .mildBlue

            stackView.addArrangedSubview(label)

            labels.append(label)
        }

        return stackView
    }

    @objc
    private func textDidChange() {
        guard let text = self.text, text.count <= labels.count else { return }

        for i in 0 ..< labels.count {
            let currentLabel = labels[i]

            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
                currentLabel.textColor = .black
            } else {
                currentLabel.text = defaultChar
                currentLabel.textColor = .mildBlue
            }
        }

        if text.count == labels.count {
            didEnterLastDigit?(text)
        }
    }

    func clearLabels() {
        for i in 0 ..< labels.count {
            let currentLabel = labels[i]
            currentLabel.text = defaultChar
            currentLabel.textColor = .mildBlue
        }
    }
}

extension OTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < labels.count || string == ""
    }
}
