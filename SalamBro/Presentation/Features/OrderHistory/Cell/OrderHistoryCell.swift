//
//  OrderTestCell.swift
//  SalamBro
//
//  Created by Arystan on 5/5/21.
//

import Reusable
import SnapKit
import UIKit

// MARK: - add viewModel logic

protocol OrderTestCellDelegate: AnyObject {
    func share()
    func rate()
}

final class OrderTestCell: UITableViewCell, Reusable {
    weak var delegate: OrderTestCellDelegate?

    private let orderView = OrderHistoryCellContentView()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension OrderTestCell {
    private func configureViews() {
        orderView.shareToInstagramButton.addTarget(self, action: #selector(shareToInstagram), for: .touchUpInside)
        orderView.rateOrderButton.addTarget(self, action: #selector(rateOrder), for: .touchUpInside)
    }

    private func layoutUI() {
        contentView.addSubview(orderView)

        orderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @objc private func rateOrder() {
        delegate?.rate()
    }

    @objc private func shareToInstagram() {
        delegate?.share()
    }
}
