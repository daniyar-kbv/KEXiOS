//
//  CartAdditionalProductCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/17/21.
//

import RxCocoa
import RxSwift
import UIKit

protocol CartAdditinalProductCellDelegate: AnyObject {
    func increment(positionUUID: String?)
    func decrement(positionUUID: String?)
    func delete(positionUUID: String?)
}

final class CartAdditionalProductCell: UITableViewCell {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
        button.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.minus), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(decreaseItemCount), for: .touchUpInside)
        return button
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.borderWidth = 1
        button.cornerRadius = 5
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
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .kexRed
        label.numberOfLines = 0
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

    private lazy var bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        return view
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: CartAdditionalProductViewModel

    weak var delegate: CartAdditinalProductCellDelegate?

    init(viewModel: CartAdditionalProductViewModel) {
        self.viewModel = viewModel

        super.init(style: .default, reuseIdentifier: .none)

        layoutUI()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CartAdditionalProductCell {
    private func bindViewModel() {
        viewModel.outputs.itemImage
            .bind(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.productImageView.setImage(url: url)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.itemTitle
            .bind(to: productTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.price
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.count
            .subscribe(onNext: { [weak self] count in
                self?.countLabel.text = count
                self?.configureButton(for: count)
            }).disposed(by: disposeBag)

        viewModel.outputs.isAvailable
            .subscribe(onNext: { [weak self] isAvailable in
                self?.updateAvailability(to: isAvailable)
            }).disposed(by: disposeBag)
    }

    private func layoutUI() {
        [productImageView, productTitleLabel, priceLabel, unavailableLabel, containerView, bottomSeparator].forEach {
            contentView.addSubview($0)
        }

        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(24)
            $0.size.equalTo(40)
        }

        productTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalTo(productImageView.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(15)
            $0.left.equalTo(productImageView.snp.right).offset(8)
            $0.bottom.equalToSuperview().offset(-24)
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
            $0.left.equalTo(priceLabel.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-16)
            $0.centerY.equalTo(priceLabel.snp.centerY)
            $0.height.equalTo(30)
            $0.width.equalTo(90)
        }

        unavailableLabel.snp.makeConstraints {
            $0.top.equalTo(productTitleLabel.snp.bottom).offset(15)
            $0.left.equalTo(productImageView.snp.right).offset(8)
            $0.bottom.equalToSuperview().offset(-24)
        }

        bottomSeparator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(0.24)
        }
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
            priceLabel.isHidden = true
            productImageView.alpha = 0.5
        }
    }

    private func configureButton(for count: String) {
        if count != "0" {
            increaseButton.backgroundColor = .kexRed
            increaseButton.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.plusWhite), for: .normal)
            increaseButton.borderColor = .clear
        } else {
            increaseButton.backgroundColor = .arcticWhite
            increaseButton.setBackgroundImage(SBImageResource.getIcon(for: CartIcons.Cart.plusGray), for: .normal)
            increaseButton.borderColor = .mildBlue
        }
    }
}

extension CartAdditionalProductCell {
    @objc private func decreaseItemCount(_: UIButton) {
        delegate?.decrement(positionUUID: viewModel.getPositionUUID())
    }

    @objc private func increaseItemButton(_: UIButton) {
        if viewModel.getCount() == 0 {
            viewModel.addItemToCart()
        }
        delegate?.increment(positionUUID: viewModel.getPositionUUID())
    }

    @objc private func deleteItem() {
        delegate?.delete(positionUUID: viewModel.getPositionUUID())
    }
}
