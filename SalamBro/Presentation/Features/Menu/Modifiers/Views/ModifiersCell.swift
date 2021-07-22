//
//  AdditionalItemCell.swift
//  DetailView
//
//  Created by Arystan on 5/2/21.
//

import SnapKit
import UIKit

class ModifiersCell: UICollectionViewCell {
    lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var itemTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        return view
    }()

    private lazy var itemPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        return view
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(modifier: Modifier) {
        itemTitleLabel.text = modifier.name
    }
}

extension ModifiersCell {
    private func layoutUI() {
        [itemImageView, itemTitleLabel, itemPriceLabel].forEach {
            contentView.addSubview($0)
        }

        itemImageView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
        }

        itemPriceLabel.snp.makeConstraints {
            $0.top.equalTo(itemTitleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
    }
}
