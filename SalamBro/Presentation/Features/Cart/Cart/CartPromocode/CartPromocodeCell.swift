//
//  CartPromocodeCell.swift
//  SalamBro
//
//  Created by Dan on 8/6/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol CartPromocodeCellDelegate {
    func promocodeTapped()
}

final class CartPromocodeCell: UITableViewCell {
    lazy var promocodeButton: UIButton = {
        let button = UIButton()
        button.setTitle(SBLocalization.localized(key: CartText.Cart.Footer.promocodeButton), for: .normal)
        button.backgroundColor = .arcticWhite
        button.setTitleColor(.kexRed, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.kexRed.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .mildBlue
        view.numberOfLines = 0
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [promocodeButton, descriptionLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: CartPromocodeViewModel

    var delegate: CartPromocodeCellDelegate?

    init(viewModel: CartPromocodeViewModel) {
        self.viewModel = viewModel

        super.init(style: .default, reuseIdentifier: .none)

        bindViewModel()
        layoutUI()
        configActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.outputs.state
            .subscribe(onNext: { [weak self] state in
                self?.process(state: state)
            })
            .disposed(by: disposeBag)
    }

    private func process(state: CartPromocodeViewModelImpl.State) {
        print("state: \(state)")
        switch state {
        case let .set(description):
            promocodeButton.isHidden = true
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        case .notSet:
            promocodeButton.isHidden = false
            descriptionLabel.isHidden = true
        }
    }

    private func layoutUI() {
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview().inset(24)
        }

        promocodeButton.snp.makeConstraints {
            $0.height.equalTo(43)
        }
    }

    private func configActions() {
        promocodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.delegate?.promocodeTapped()
            })
            .disposed(by: disposeBag)
    }
}
