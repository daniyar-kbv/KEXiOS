//
//  PaymentMethodCell.swift
//  SalamBro
//
//  Created by Dan on 7/15/21.
//

import Foundation
import UIKit

final class PaymentMethodCell: UITableViewCell {
    private lazy var applePayImage: UIImageView = {
        let view = UIImageView()
        view.image = SBImageResource.getIcon(for: PaymentIcons.PaymentMethod.applePay)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.textColor = .darkGray
        return view
    }()

    private lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [applePayImage, titleLabel])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 10
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

    func configure(title: String, isSelected: Bool, isApplePay: Bool) {
        titleLabel.text = title
        rightImageView.isHidden = !isSelected
        applePayImage.isHidden = !isApplePay
    }

    private func layoutUI() {
        selectionStyle = .none

        [rightImageView, titleStack].forEach { addSubview($0) }

        applePayImage.snp.makeConstraints {
            $0.size.equalTo(30)
        }

        rightImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-21)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleStack.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(rightImageView.snp.left).offset(-21)
            $0.centerY.equalToSuperview()
        }
    }
}
