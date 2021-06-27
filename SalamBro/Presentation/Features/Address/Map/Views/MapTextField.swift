//
//  MapTextField.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 03.06.2021.
//

import UIKit

final class MapTextField: UITextField {
    init(image: UIImage? = nil) {
        super.init(frame: .zero)
        configure(image: image)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(image: UIImage?) {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = .lightGray
        guard let image = image else { return }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        rightView = imageView
        rightViewMode = .always
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= 16 / 2
        return textRect
    }
}

extension MapTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        return false
    }
}
