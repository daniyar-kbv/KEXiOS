//
//  OrderHistoryItemStackView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import SnapKit
import UIKit

final class OrderHistoryItemView: UIView {
    private var itemLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    private var priceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.numberOfLines = 0
        return view
    }()

    init() {
        super.init(frame: .zero)
        layoutUI()
    }

    init(with title: String, and price: String) {
        super.init(frame: .zero)
        itemLabel.text = title
        priceLabel.text = price
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [itemLabel, priceLabel].forEach {
            addSubview($0)
        }
        itemLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.equalToSuperview()
            $0.width.lessThanOrEqualTo(220)
        }
        priceLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.equalTo(itemLabel.snp.right).offset(4)
            $0.right.equalToSuperview()
        }
    }

    func configure(with title: String, and price: String) {
        itemLabel.text = title
        priceLabel.text = price
    }
}
