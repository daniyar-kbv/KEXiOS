//
//  OrderTestCell.swift
//  SalamBro
//
//  Created by Arystan on 5/5/21.
//

import Reusable
import SnapKit
import UIKit

protocol OrderTestCellDelegate: AnyObject {
    func share()
    func rate(at orderNumber: Int)
}

final class OrderTestCell: UITableViewCell, Reusable {
    weak var delegate: OrderTestCellDelegate?

    private var orderView: OrderHistoryCellContentView?

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        orderView = OrderHistoryCellContentView(delegate: self)
        layoutUI()
        orderView?.configureActions()
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        orderView?.setDefaultLogo()
    }
}

extension OrderTestCell {
    private func layoutUI() {
        guard let orderView = orderView else { return }
        contentView.addSubview(orderView)

        orderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with item: OrdersList) {
        orderView?.configure(with: item)
    }
}

extension OrderTestCell: OrderHistoryViewDelegate {
    func shareToInstagramTapped() {
        delegate?.share()
    }

    func rateOrder(at orderNumber: Int) {
        delegate?.rate(at: orderNumber)
    }
}
