//
//  PaymentEditCell.swift
//  SalamBro
//
//  Created by Dan on 7/29/21.
//

import Foundation
import UIKit

final class PaymentEditCell: UITableViewCell {
    private lazy var cardLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .darkGray
        return view
    }()

    private lazy var rightImage: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [rightImage, cardLabel].forEach { addSubview($0) }

        rightImage.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }

        cardLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(rightImage.snp.left).offset(10)
        }
    }

    func configure(cardTitle: String, isSelected: Bool) {
        cardLabel.text = cardTitle
        rightImage.image = SBImageResource.getIcon(for:
            isSelected ?
                PaymentIcons.PaymentEdit.Checkmark.filled :
                PaymentIcons.PaymentEdit.Checkmark.empty
        )
    }
}
