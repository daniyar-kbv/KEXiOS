//
//  PaymentMethodCell.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation
import UIKit

final class PaymentMethodCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .darkGray
        return view
    }()

    private lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.image = SBImageResource.getIcon(for: PaymentIcons.PaymentMethod.selected)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        rightImageView.isHidden = !isSelected
    }

    private func layoutUI() {
        selectionStyle = .none

        [rightImageView, titleLabel].forEach { addSubview($0) }

        rightImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-21)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(rightImageView.snp.left).offset(-21)
            $0.centerY.equalToSuperview()
        }
    }
}
