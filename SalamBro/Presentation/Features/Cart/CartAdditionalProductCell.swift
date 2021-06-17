//
//  CartAdditionalProductCell2.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/17/21.
//

import Reusable
import UIKit

protocol CellDelegate {
    func deleteProduct(id: Int, isAdditional: Bool)
    func changeItemCount(id: Int, isIncrease: Bool, isAdditional: Bool)
}

class CartAdditionalProductCell: UITableViewCell {
    private var productImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "fastFood")
        return view
    }()

    private var titlesStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()

    private var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private var containerView: UIView = {
        let view = UIView()
        return view
    }()

    private var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 0
        return view
    }()

    private var descreaseButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.borderColor = .darkGray
        button.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "minus"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // button.addTarget(self, action: #selector(decreaseItemCount), for: .touchUpInside)
        return button
    }()

    private var increaseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.cornerRadius = 5
        // button.setBackgroundImage(UIImage(named: "plus"), for: .normal)
        // button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // button.addTarget(self, action: #selector(increaseItemButton), for: .touchUpInside)
        return button
    }()

    private var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .lightGray
        return label
    }()

    private var unavailableLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .kexRed
        label.numberOfLines = 0
        return label
    }()

    var product: CartAdditionalProduct!
    var counter: Int = 0
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

extension CartAdditionalProductCell {
    private func layoutUI() {
        [productImageView, titlesStackView, unavailableLabel, containerView].forEach {
            contentView.addSubview($0)
        }

        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(26)
            $0.width.equalTo(64)
            $0.height.equalTo(54)
        }

        titlesStackView = UIStackView(arrangedSubviews: [productTitleLabel, priceLabel])

        productTitleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(4)
            $0.left.right.bottom.equalToSuperview()
        }

        titlesStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
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
            $0.left.equalTo(titlesStackView.snp.right).offset(8)
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

    func bindData(item: CartAdditionalProduct) {
        product = item
        productTitleLabel.text = product.name
        priceLabel.text = "\(product.count * product.price) ₸"
        countLabel.text = "\(product.count)"
        counter = product.count

        if product!.available {
            unavailableLabel.text = ""
        } else {
            unavailableLabel.text = L10n.CartAdditionalProductCell.Availability.title
            productTitleLabel.alpha = 0.5
            priceLabel.alpha = 0.5
            productImageView.alpha = 0.5
        }
        counter = product!.count
        countLabel.text = "\(counter)"
    }

    @objc func decreaseItemCount(_: UIButton) {
        if counter > 0 {
            counter -= 1
            delegate.changeItemCount(id: product.id, isIncrease: false, isAdditional: true)
            priceLabel.text = "\(counter * product!.price) T"
            countLabel.text = "\(counter)"
        }
    }

    @objc func increaseItemButton(_: UIButton) {
        if counter < 999 {
            counter += 1
            delegate.changeItemCount(id: product.id, isIncrease: true, isAdditional: true)
            priceLabel.text = "\(counter * product!.price) T"
            countLabel.text = "\(counter)"
        }
    }
}

extension CartAdditionalProductCell: Reusable {}
