//
//  MapActionButton.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 23.05.2021.
//

import UIKit

final class MapActionButton: UIButton {
    init(image: UIImage?) {
        super.init(frame: .zero)
        configure(image: image)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
    }

    private func configure(image: UIImage?) {
        backgroundColor = .white
        setImage(image, for: .normal)
        layer.cornerRadius = 22
        layer.masksToBounds = true
    }

    private func setShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 14
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath

        clipsToBounds = false
    }
}
