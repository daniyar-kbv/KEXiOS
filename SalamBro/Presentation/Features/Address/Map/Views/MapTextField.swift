//
//  MapTextField.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 03.06.2021.
//

import UIKit

final class MapTextField: UITextView {
    var placeholder: String = "" {
        didSet {
            guard isEmpty else { return }
            text = placeholder
        }
    }

    private var isEmpty: Bool = true {
        didSet {
            textColor = isEmpty ? .mildBlue : .darkGray
            autocapitalizationType = isEmpty ? .words : .sentences
        }
    }

    private var imageView: UIImageView?

    var onShouldBeginEditing: (() -> Void)?

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
        autocapitalizationType = .words

        delegate = self

        set(image: image)
    }

    func set(text: String?) {
        guard text?.isEmpty == false else { return }
        self.text = text
        isEmpty = false
    }

    private func set(image: UIImage?) {
        guard let image = image else { return }
        imageView = UIImageView(image: image)
        guard let imageView = imageView else { return }
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 40)
    }

    private func moveCursor() {
        selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
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
        moveCursor()
    }

    func textViewDidEndEditing(_: UITextView) {
        guard isEmpty else { return }
        text = placeholder
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        if isEmpty, text != "" {
            textView.text = text
            textColor = .darkGray
            isEmpty = false
            return false
        }

        if !isEmpty, newText == "" {
            textView.text = placeholder
            isEmpty = true
            moveCursor()
            return false
        }

        return true
    }
}
