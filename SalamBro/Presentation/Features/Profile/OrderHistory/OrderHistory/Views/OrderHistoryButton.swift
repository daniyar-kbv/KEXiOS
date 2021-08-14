//
//  OrderHistoryButton.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import UIKit

final class OrderHistoryButton: UIButton {
    required init(color: UIColor, titleString: String) {
        super.init(frame: .zero)
        borderColor = color
        setTitleColor(color, for: .normal)
        setTitle(titleString, for: .normal)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        backgroundColor = .arcticWhite
        borderWidth = 1
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cornerRadius = 10
        layer.masksToBounds = true
    }
}
