//
//  AddressCell.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import SnapKit
import UIKit

final class AddressListCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var rightArrowImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.chevronRight.image)

//         MARK: SwiftGen issue, почему-то икнока chevronRight смотрит вниз 😒

        imageView.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        imageView.tintColor = .mildBlue
        return imageView
    }()

    static let reuseIdentifier = "AddressListCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressListCell {
    func configure(address: String) {
        titleLabel.text = address
    }

    private func layoutUI() {
        selectionStyle = .none
        contentView.backgroundColor = .white

        [titleLabel, rightArrowImageView].forEach {
            contentView.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.greaterThanOrEqualTo(24)
        }

        rightArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
    }
}
