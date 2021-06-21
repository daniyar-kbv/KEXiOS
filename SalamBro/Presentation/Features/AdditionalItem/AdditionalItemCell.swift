//
//  AdditionalItemCell.swift
//  DetailView
//
//  Created by Arystan on 5/2/21.
//

import SnapKit
import UIKit

final class AdditionalItemCell: UICollectionViewCell {
    private lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cola")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var itemTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Вода “Coca-Cola” 0,5 л"
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        return view
    }()

    private lazy var itemPriceLabel: UILabel = {
        let view = UILabel()
        view.text = "0 ₸"
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
}

extension AdditionalItemCell {
    private func layoutUI() {
        [itemImageView, itemTitleLabel, itemPriceLabel].forEach {
            contentView.addSubview($0)
        }

        itemImageView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
        }

        itemPriceLabel.snp.makeConstraints {
            $0.top.equalTo(itemTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
        }
    }
}
