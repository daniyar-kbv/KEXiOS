//
//  CartProductCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/17/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class CartProductCell: UITableViewCell {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "fastFood")
        view.contentMode = .scaleAspectFit
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
        button.setTitle(SBLocalization.localized(key: CartText.Cart.ProductCell.deleteButton), for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return button
    }()

    private var viewModel: CartProductViewModel!
    private let disposeBag = DisposeBag()

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

extension CartProductCell {
    private func layoutUI() {
        [productImageView, productTitleLabel, subitemLabel, commentLabel, priceLabel, unavailableLabel, containerView].forEach {
            contentView.addSubview($0)
        }

        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }

        productTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalTo(productImageView.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
        }

        subitemLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(4)
            $0.left.equalTo(productImageView.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
        }

        commentLabel.snp.makeConstraints {
            $0.top.equalTo(subitemLabel.snp.bottom).offset(2)
            $0.left.equalTo(productImageView.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(26)
            $0.left.equalToSuperview().offset(72)
            $0.bottom.equalToSuperview().offset(-19)
        }

        unavailableLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(26)
            $0.left.equalToSuperview().offset(72)
            $0.bottom.equalToSuperview().offset(-19)
        }

        stackView = UIStackView(arrangedSubviews: [descreaseButton, countLabel, increaseButton])

        descreaseButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }

        countLabel.snp.makeConstraints {
            $0.left.equalTo(descreaseButton.snp.right)
            $0.top.equalTo(stackView).offset(1)
            $0.right.equalTo(increaseButton.snp.left)
            $0.bottom.equalTo(stackView).offset(-1)
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
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(30)
            $0.width.equalTo(90)
        }
    }
}

extension CartProductCell {
    func configure(with item: CartItem) {
        viewModel = CartProductViewModelImpl(inputs: .init(item: item))

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.outputs.itemTitle
            .bind(to: productTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.modifiersTitles
            .bind(to: subitemLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.comment
            .bind(to: commentLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.price
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.count
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.isAvailable
            .subscribe(onNext: { [weak self] isAvailable in
                self?.updateAvailability(to: isAvailable)
            }).disposed(by: disposeBag)
    }

    private func updateAvailability(to isAvailable: Bool) {
        if isAvailable {
            deleteButton.isHidden = true
            unavailableLabel.isHidden = true
        } else {
            stackView.isHidden = true
            deleteButton.isHidden = false
            unavailableLabel.text = SBLocalization.localized(key: CartText.Cart.ProductCell.availability)
            productTitleLabel.alpha = 0.5
            subitemLabel.alpha = 0.5
            priceLabel.isHidden = true
            productImageView.alpha = 0.5
        }
    }

    @objc private func increaseItemButton() {
        delegate?.increment(positionUUID: viewModel.getPositionUUID(), isAdditional: false)
    }

    @objc private func decreaseItemCount() {
        delegate?.decrement(positionUUID: viewModel.getPositionUUID(), isAdditional: false)
    }

    @objc private func deleteItem() {
        delegate?.delete(positionUUID: viewModel.getPositionUUID(), isAdditional: false)
    }
}

extension CartProductCell: Reusable {}
