//
//  AdditionalItemCell.swift
//  DetailView
//
//  Created by Arystan on 5/2/21.
//

import Reusable
import SnapKit
import UIKit

protocol ModifiersCellDelegate: AnyObject {
    func decreaseQuantity(at index: Int, with count: Int)
    func increaseQuantity(at index: Int, with count: Int)
}

final class ModifiersCell: UICollectionViewCell {
    private lazy var itemImageView: UIImageView = {
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

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.descreaseButton,
            self.countLabel,
            self.increaseButton,
        ])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = 0
        return view
    }()

    private lazy var descreaseButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.cornerRadius = 5
        button.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.minus), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(decreaseItemCount), for: .touchUpInside)
        return button
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.cornerRadius = 5
        button.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.plusGray), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(increaseItemCount), for: .touchUpInside)
        return button
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()

    private var itemCount = 0

    private var index = 0

    weak var delegate: ModifiersCellDelegate?

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(modifier: Modifier, index: Int) {
        itemTitleLabel.text = modifier.name
        countLabel.text = "\(modifier.itemCount)"
        itemCount = modifier.itemCount
        self.index = index

        if modifier.itemCount > 0 {
            increaseButton.borderColor = .clear
            increaseButton.backgroundColor = .kexRed
            increaseButton.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.plusWhite), for: .normal)
            itemImageView.borderColor = .kexRed
            itemImageView.borderWidth = 1
        } else {
            increaseButton.borderColor = .mildBlue
            increaseButton.backgroundColor = .clear
            increaseButton.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.plusGray), for: .normal)
            itemImageView.borderColor = .clear
        }
    }

    func configureUI(with status: (Bool, Bool)) {
        switch status {
        case (true, true):
            contentView.alpha = 1
            contentView.isUserInteractionEnabled = true
            increaseButton.alpha = 1
            increaseButton.isUserInteractionEnabled = true
        case (true, false):
            increaseButton.alpha = 0.5
            increaseButton.isUserInteractionEnabled = false
        case (false, false):
            contentView.alpha = 0.5
            contentView.isUserInteractionEnabled = false
        default:
            contentView.alpha = 1
        }
    }
}

extension ModifiersCell {
    private func layoutUI() {
        [itemImageView, itemTitleLabel, itemPriceLabel, stackView].forEach {
            contentView.addSubview($0)
        }

        itemImageView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }

        itemPriceLabel.snp.makeConstraints {
            $0.top.equalTo(itemTitleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }

        descreaseButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.height.equalTo(30)
        }

        countLabel.snp.makeConstraints {
            $0.left.equalTo(descreaseButton.snp.right)
            $0.right.equalTo(increaseButton.snp.left)
            $0.top.bottom.equalToSuperview()
        }

        increaseButton.snp.makeConstraints {
            $0.left.equalTo(countLabel.snp.right)
            $0.top.right.bottom.equalToSuperview()
            $0.width.height.equalTo(30)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(itemPriceLabel.snp.bottom).offset(4)
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
}

extension ModifiersCell {
    @objc private func decreaseItemCount() {
        if itemCount > 0 {
            itemCount = itemCount - 1
        }
        delegate?.decreaseQuantity(at: index, with: itemCount)
    }

    @objc private func increaseItemCount() {
        itemCount = itemCount + 1
        delegate?.increaseQuantity(at: index, with: itemCount)
    }
}

extension ModifiersCell: Reusable {}
