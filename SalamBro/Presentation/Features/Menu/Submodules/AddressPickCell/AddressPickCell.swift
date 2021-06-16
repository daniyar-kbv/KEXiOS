//
//  AddressPickCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class AddressPickCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()

    public let deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.AddressPickCell.deliverLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .mildBlue
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    public let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let changeButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.AddressPickCell.changeButton, for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.adjustsImageWhenHighlighted = true
        button.adjustsImageWhenDisabled = true
        button.isUserInteractionEnabled = false
        return button
    }()

    private var viewModel: AddressPickCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: AddressPickCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.address
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension AddressPickCell {
    private func layoutUI() {
        [deliveryLabel, addressLabel, changeButton].forEach {
            containerView.addSubview($0)
        }

        contentView.addSubview(containerView)

        deliveryLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(deliveryLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview()
        }

        changeButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(addressLabel.snp.centerY)
        }

        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-15)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(35)
        }
    }
}

extension AddressPickCell: Reusable {}
