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
        view.image = SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
        return view
    }()

    private lazy var itemTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()

    private lazy var itemPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        view.setContentCompressionResistancePriority(.required, for: .vertical)
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

    private var imageURL: String?

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if itemImageView.image == nil {
            itemImageView.image =
                SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
        }
    }

    func configure(modifier: Modifier, index: Int) {
        if modifier.image == nil, modifier.image != imageURL {
            itemImageView.image =
                SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
        } else if let urlString = modifier.image, let url = URL(string: urlString) {
            itemImageView.setImage(url: url)
            imageURL = urlString
        }

        itemTitleLabel.text = modifier.name
        itemPriceLabel.text = SBLocalization.localized(key: MenuText.Modifier.price,
                                                       arguments: String(modifier.price))
        countLabel.text = "\(modifier.itemCount)"
        itemCount = modifier.itemCount
        self.index = index

        increaseButton.borderColor = modifier.itemCount > 0 ? .clear : .mildBlue
        increaseButton.backgroundColor = modifier.itemCount > 0 ? .kexRed : .clear
        let image = modifier.itemCount > 0 ? SBImageResource.getIcon(for: CartIcons.Cart.plusWhite) :
            SBImageResource.getIcon(for: CartIcons.Cart.plusGray)
        increaseButton.setBackgroundImage(image, for: .normal)
        itemImageView.borderColor = modifier.itemCount > 0 ? .kexRed : .clear
        itemImageView.borderWidth = modifier.itemCount > 0 ? 1 : 0
    }

    func configureUI(with status: (Bool, Bool)) {
        switch status {
        case (true, true):
            increaseButton.alpha = 1
            itemImageView.alpha = 1
            descreaseButton.alpha = 1
            countLabel.alpha = 1
            itemTitleLabel.alpha = 1
            itemPriceLabel.alpha = 1
            increaseButton.isUserInteractionEnabled = true
            contentView.isUserInteractionEnabled = true
        case (true, false):
            itemImageView.alpha = 1
            descreaseButton.alpha = 1
            countLabel.alpha = 1
            itemTitleLabel.alpha = 1
            itemPriceLabel.alpha = 1
            increaseButton.alpha = 0.5
            increaseButton.isUserInteractionEnabled = false
        case (false, false):
            itemImageView.alpha = 0.5
            descreaseButton.alpha = 0.5
            countLabel.alpha = 0.5
            increaseButton.alpha = 0.5
            itemTitleLabel.alpha = 0.5
            itemPriceLabel.alpha = 0.5
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
            delegate?.decreaseQuantity(at: index, with: itemCount)
        }
    }

    @objc private func increaseItemCount() {
        itemCount = itemCount + 1
        delegate?.increaseQuantity(at: index, with: itemCount)
    }
}

extension ModifiersCell: Reusable {}
