//
//  CartProductCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/17/21.
//

import Reusable
import UIKit

final class CartProductCell: UITableViewCell {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "fastFood")
        return view
    }()

    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var subitemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var unavailableLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .kexRed
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

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.cornerRadius = 5
        button.setTitle(L10n.CartProductCell.DeleteButton.title, for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return button
    }()

    private var counter: Int = 0
    lazy var product: CartProduct? = nil
    var delegate: CellDelegate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartProductCell {
    private func layoutUI() {
        [productImageView, productTitleLabel, subitemLabel, commentLabel, priceLabel, unavailableLabel, containerView].forEach {
            contentView.addSubview($0)
        }

        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(26)
            $0.width.equalTo(64)
            $0.height.equalTo(54)
        }

        productTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalTo(productImageView.snp.right).offset(7)
            $0.right.equalToSuperview().offset(-22)
        }

        subitemLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(4)
            $0.left.equalTo(productImageView.snp.right).offset(7)
            $0.right.equalToSuperview().offset(-22)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(subitemLabel.snp.bottom).offset(2)
            $0.left.equalTo(productImageView.snp.right).offset(7)
            $0.right.equalToSuperview().offset(-22)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(26)
            $0.left.equalToSuperview().offset(97)
            $0.bottom.equalToSuperview().offset(-18)
        }

        unavailableLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(26)
            $0.left.equalToSuperview().offset(97)
            $0.bottom.equalToSuperview().offset(-18)
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

        [stackView, deleteButton].forEach {
            containerView.addSubview($0)
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0.5)
            $0.bottom.equalToSuperview().offset(-1.5)
            $0.left.right.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.left.equalTo(unavailableLabel.snp.right).offset(3)
            $0.left.equalTo(priceLabel.snp.right).offset(16)
            $0.bottom.equalToSuperview().offset(-11)
            $0.right.equalToSuperview().offset(-22)
            $0.height.equalTo(30)
            $0.width.equalTo(90)
        }
    }
}

extension CartProductCell {
    func bindData(with item: CartProduct) {
        product = item
        productTitleLabel.text = product!.name
        subitemLabel.text = product!.description
        priceLabel.text = "\(product!.price * product!.count) ₸"
        commentLabel.text = product!.commentary

        if product!.available {
            deleteButton.isHidden = true
            unavailableLabel.isHidden = true
        } else {
            stackView.isHidden = true
            deleteButton.isHidden = false
            unavailableLabel.text = L10n.CartProductCell.Availability.title
            productTitleLabel.alpha = 0.5
            subitemLabel.alpha = 0.5
            priceLabel.isHidden = true
            productImageView.alpha = 0.5
        }
        counter = product!.count
        countLabel.text = "\(counter)"
    }

    @objc func decreaseItemCount() {
        if counter > 0 {
            counter -= 1
            delegate.changeItemCount(id: product!.id, isIncrease: false, isAdditional: false)
            priceLabel.text = "\(counter * product!.price) ₸"
            countLabel.text = "\(counter)"
        } else {
            delegate.deleteProduct(id: product!.id, isAdditional: false)
        }
    }

    @objc func increaseItemButton() {
        if counter < 999 {
            counter += 1
            delegate.changeItemCount(id: product!.id, isIncrease: true, isAdditional: false)
            priceLabel.text = "\(counter * product!.price) ₸"
            countLabel.text = "\(counter)"
        }
    }

    @objc func deleteItem() {
        delegate.deleteProduct(id: product!.id, isAdditional: false)
    }
}

extension CartProductCell: Reusable {}
