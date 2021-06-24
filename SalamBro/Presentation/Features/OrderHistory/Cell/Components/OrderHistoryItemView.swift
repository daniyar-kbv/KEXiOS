//
//  OrderHistoryItemStackView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import SnapKit
import UIKit

final class OrderHistoryItemView: UIView {
    var itemLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        return view
    }()

    var priceLabel: UILabel = {
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
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
