//
//  OrderHistoryItemStackView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import SnapKit
import UIKit

final class OrderHistoryItemStackView: UIStackView {
    private lazy var itemLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14)
        view.textColor = .darkGray
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 14)
        view.textColor = .darkGray
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()

    init() {
        super.init(frame: .zero)
        configureUI()
    }

    init(with title: String, and price: String) {
        super.init(frame: .zero)
        itemLabel.text = title
        priceLabel.text = price
        configureUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        axis = .horizontal
        alignment = .center
        spacing = 8

        addArrangedSubview(itemLabel)
        addArrangedSubview(priceLabel)
    }

    func configure(with title: String, and price: String) {
        itemLabel.text = title
        priceLabel.text = price
    }
}
