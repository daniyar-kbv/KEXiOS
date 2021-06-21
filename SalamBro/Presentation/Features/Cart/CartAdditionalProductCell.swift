//
//  CartAdditionalProductCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/17/21.
//

import Reusable
import UIKit

protocol CartAdditinalProductCellDelegate: AnyObject {
    func deleteProduct(id: Int, isAdditional: Bool)
    func changeItemCount(id: Int, isIncrease: Bool, isAdditional: Bool)
}

final class CartAdditionalProductCell: UITableViewCell {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ketchup")
        return view
    }()

    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()

    private lazy var descreaseButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "minus"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(decreaseItemCount), for: .touchUpInside)
        return button
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "plus"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(increaseItemButton), for: .touchUpInside)
        return button
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
    }()

    private lazy var unavailableLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .kexRed
        label.numberOfLines = 0
        return label
    }()

    private var product: CartAdditionalProduct?
    private var counter: Int = 0
    var delegate: CartAdditinalProductCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartAdditionalProductCell {
    private func layoutUI() {
        [productImageView, productTitleLabel, priceLabel, unavailableLabel, containerView].forEach {
            contentView.addSubview($0)
        }

        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(26)
            $0.width.equalTo(64)
            $0.height.equalTo(64)
        }

        productTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.left.equalTo(productImageView.snp.right).offset(8)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(6)
            $0.left.equalTo(productImageView.snp.right).offset(8)
        }

        stackView = UIStackView(arrangedSubviews: [descreaseButton, countLabel, increaseButton])

        descreaseButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }

        countLabel.snp.makeConstraints {
            $0.left.equalTo(descreaseButton.snp.right)
            $0.top.equalTo(stackView).offset(3)
            $0.right.equalTo(increaseButton.snp.left)
            $0.bottom.equalTo(stackView).offset(-3)
            $0.width.equalTo(30)
        }

        increaseButton.snp.makeConstraints {
            $0.left.equalTo(countLabel.snp.right)
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }

        containerView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.left.equalTo(productTitleLabel.snp.right).offset(8)
            $0.top.equalToSuperview().offset(34)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(30)
            $0.width.equalTo(90)
        }

        unavailableLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}

extension CartAdditionalProductCell {
    func configure(item: CartAdditionalProduct) {
        product = item
        if let count = product?.count, let price = product?.price, let isAvailable = product?.available {
            productTitleLabel.text = product?.name

            priceLabel.text = "\(count * price) ₸"
            countLabel.text = "\(count)"
            counter = count

            if isAvailable {
                unavailableLabel.text = ""
            } else {
                unavailableLabel.text = L10n.CartAdditionalProductCell.Availability.title
                productTitleLabel.alpha = 0.5
                priceLabel.alpha = 0.5
                productImageView.alpha = 0.5
            }
            counter = count
            countLabel.text = "\(counter)"
        }
    }

    @objc private func decreaseItemCount(_: UIButton) {
        if counter > 0 {
            counter -= 1
            if let id = product?.id, let price = product?.price {
                delegate?.changeItemCount(id: id, isIncrease: false, isAdditional: true)
                priceLabel.text = "\(counter * price) T"
            }
            countLabel.text = "\(counter)"
        }
    }

    @objc private func increaseItemButton(_: UIButton) {
        if counter < 999 {
            counter += 1
            if let id = product?.id, let price = product?.price {
                delegate?.changeItemCount(id: id, isIncrease: true, isAdditional: true)
                priceLabel.text = "\(counter * price) T"
            }
            countLabel.text = "\(counter)"
        }
    }
}

extension CartAdditionalProductCell: Reusable {}
