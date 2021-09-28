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
    func increment(internalUUID: String?)
    func decrement(internalUUID: String?)
    func delete(internalUUID: String?)

    func incrementAdditionalItem(item: CartItem)
    func decrementAdditionalItem(item: CartItem)
    func deleteAdditionalItem(item: CartItem)
}

final class CartAdditionalProductCell: UITableViewCell {
    private lazy var productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image =
            SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
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

    private lazy var decreaseButton: UIButton = {
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

    override func prepareForReuse() {
        super.prepareForReuse()
        if productImageView.image == nil {
            productImageView.image =
                SBImageResource.getIcon(for: MenuIcons.Menu.dishPlaceholder)
        }
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

        stackView = UIStackView(arrangedSubviews: [decreaseButton, countLabel, increaseButton])

        decreaseButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(30)
        }

        countLabel.snp.makeConstraints {
            $0.left.equalTo(decreaseButton.snp.right)
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
            $0.height.equalTo(0.5)
        }
    }

    private func updateAvailability(to isAvailable: Bool) {
        deleteButton.isHidden = isAvailable ? isAvailable : !viewModel.isInUsersCart()

        unavailableLabel.isHidden = isAvailable
        increaseButton.isHidden = !isAvailable
        decreaseButton.isHidden = !isAvailable
        countLabel.isHidden = !isAvailable
        priceLabel.isHidden = !isAvailable

        productTitleLabel.alpha = isAvailable ? 1 : 0.25
        productImageView.alpha = isAvailable ? 1 : 0.25

        unavailableLabel.text = SBLocalization.localized(key: CartText.Cart.ProductCell.availability)
    }

    private func configureButton(for count: String) {
        increaseButton.backgroundColor = count != "0" ? .kexRed : .arcticWhite
        increaseButton.borderColor = count != "0" ? .clear : .mildBlue

        let imageType = count != "0" ? CartIcons.Cart.plusWhite : CartIcons.Cart.plusGray
        increaseButton.setBackgroundImage(SBImageResource.getIcon(for: imageType), for: .normal)
    }
}

extension CartAdditionalProductCell {
    @objc private func decreaseItemCount(_: UIButton) {
        delegate?.decrementAdditionalItem(item: viewModel.getItem())
    }

    @objc private func increaseItemButton(_: UIButton) {
        delegate?.incrementAdditionalItem(item: viewModel.getItem())
    }

    @objc private func deleteItem() {
        delegate?.deleteAdditionalItem(item: viewModel.getItem())
    }
}
