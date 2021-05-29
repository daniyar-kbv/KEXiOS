//
//  AddressCell.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import UIKit

final class AddressListTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()

    private let rightArrowImageView: UIImageView = {
        let imgV = UIImageView(image: Asset.chevronRight.image)

//         MARK: SwiftGen issue, почему-то икнока chevronRight смотрит вниз 😒

        imgV.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        imgV.tintColor = .mildBlue
        return imgV
    }()

    static let reuseIdentifier = "AddressListTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressListTableViewCell {
    func configure(address: String) {
        titleLabel.text = address
    }

    private func layoutUI() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.greaterThanOrEqualTo(24)
        }

        contentView.addSubview(rightArrowImageView)
        rightArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(24)
            $0.width.equalTo(24)
        }
    }
}
