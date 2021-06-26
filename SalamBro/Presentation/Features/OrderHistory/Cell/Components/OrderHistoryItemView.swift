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
        return view
    }()

    private var priceLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        return view
    }()

    init(title: String, price: String) {
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
        }
        priceLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.right.equalToSuperview()
        }
    }
}
