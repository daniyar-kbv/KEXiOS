//
//  MapTextField.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 03.06.2021.
//

import UIKit

final class MapTextField: UITextView {
    var inputType: InputType = .text

    var placeholder: String = "" {
        didSet {
            guard isEmpty else { return }
            text = placeholder
        }
    }

    private(set) var isEmpty: Bool = true {
        didSet {
            textColor = isEmpty ? .mildBlue : .darkGray
        }
    }

    private var imageView: UIImageView?

    var onShouldBeginEditing: (() -> Void)?
    var onChange: (() -> Void)?

    init(image: UIImage? = nil) {
        super.init(frame: .zero, textContainer: .none)

        configure(with: image)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView?.frame = CGRect(x: bounds.maxX - 32, y: 13, width: 24, height: 24)
    }

    private func configure(with image: UIImage?) {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        textColor = .mildBlue
        backgroundColor = .lightGray
        font = .systemFont(ofSize: 16, weight: .medium)
        isScrollEnabled = false
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        delegate = self

        set(image: image)
    }

    private func set(image: UIImage?) {
        guard let image = image else { return }
        imageView = UIImageView(image: image)
        guard let imageView = imageView else { return }
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 40)
    }

    private func formatText() {
        switch inputType {
        case .decimal:
            guard let intValue = Int(text.replacingOccurrences(of: " ", with: "")) else { return }
            text = intValue.formattedWithSeparator
        default:
            break
        }
    }
}

extension MapTextField {
    func getText() -> String {
        return isEmpty ? "" : text
    }

    func set(text: String?) {
        guard !(text?.isEmpty ?? true) else {
            self.text = placeholder
            isEmpty = true
            return
        }
        self.text = text
        isEmpty = false
    }
}

extension MapTextField: UITextViewDelegate {
    func textViewShouldBeginEditing(_: UITextView) -> Bool {
        guard let onShouldBeginEditing = onShouldBeginEditing else {
            return true
        }
        onShouldBeginEditing()
        return false
    }

    func textViewDidBeginEditing(_: UITextView) {
        guard isEmpty else { return }
    }

    func textViewDidEndEditing(_: UITextView) {
        guard isEmpty else { return }
        text = placeholder
    }

    func textViewDidChange(_ textView: UITextView) {
        if isEmpty {
            if textView.text.count - placeholder.count == 1 {
                textView.text = "\(text.last ?? String.Element(""))".capitalized
                isEmpty = false
            } else {
                textView.text = placeholder
            }
        }

        if !isEmpty, textView.text == "" {
            textView.text = placeholder
            isEmpty = true
        }

        onChange?()
        formatText()
    }
}

extension MapTextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return isEmpty ? .zero : super.caretRect(for: position)
    }
}

extension MapTextField {
    enum InputType {
        case text
        case decimal
    }
}
