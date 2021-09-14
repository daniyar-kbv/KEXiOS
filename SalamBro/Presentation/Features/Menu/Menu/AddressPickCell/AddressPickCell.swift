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
    public lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: MenuText.Menu.Address.addressTitle)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .mildBlue
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    public lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var changeButton: SBTextButton = {
        let button = SBTextButton()
        button.setTitle(SBLocalization.localized(key: MenuText.Menu.Address.changeButton), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.isUserInteractionEnabled = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.snp.makeConstraints {
            $0.width.equalTo(75)
        }
        return button
    }()

    private lazy var bottomStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [addressLabel, changeButton])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 24
        return view
    }()

    private var viewModel: AddressPickCellViewModelProtocol! {
        didSet {
            bind()
        }
    }

    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()

        selectionStyle = .none
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
        [deliveryLabel, bottomStack].forEach {
            contentView.addSubview($0)
        }

        deliveryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }

        bottomStack.snp.makeConstraints {
            $0.top.equalTo(deliveryLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-11)
        }
    }
}

extension AddressPickCell: Reusable {}
