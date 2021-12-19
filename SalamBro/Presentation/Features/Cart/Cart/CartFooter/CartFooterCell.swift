//
//  CartFooter.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import RxCocoa
import RxSwift
import UIKit

final class CartFooterCell: UITableViewCell {
    private lazy var countLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .darkGray
        return view
    }()

    private lazy var productsPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .darkGray
        view.textAlignment = .right
        return view
    }()

    private lazy var topStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [countLabel, productsPriceLabel])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        return view
    }()

    private lazy var deliveryTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .darkGray
        view.text = SBLocalization.localized(key: CartText.Cart.Footer.deliveryTitle)
        return view
    }()

    private lazy var deliveryPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .darkGray
        view.textAlignment = .right
        return view
    }()

    private lazy var bottomStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [deliveryTitleLabel, deliveryPriceLabel])
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topStack, bottomStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 8
        return view
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: CartFooterViewModel

    init(viewModel: CartFooterViewModel) {
        self.viewModel = viewModel

        super.init(style: .default, reuseIdentifier: .none)

        bindViewModel()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.outputs.countText
            .bind(onNext: { [weak self] count in
                self?.countLabel.text = self?.setLocalizationForCount(with: count)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.productsPrice
            .bind(to: productsPriceLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.deliveryPrice
            .bind(to: deliveryPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-9)
            $0.left.right.equalToSuperview().inset(24)
        }
    }

    private func setLocalizationForCount(with count: Int) -> String {
        switch count {
        case 1:
            return SBLocalization.localized(key: CartText.Cart.Footer.productsCount,
                                            arguments: count.formattedWithSeparator)
        case 2 ... 4:
            return SBLocalization.localized(key: CartText.Cart.Footer.productsCountLessOrEqualFour,
                                            arguments: count.formattedWithSeparator)
        case 5...:
            return SBLocalization.localized(key: CartText.Cart.Footer.productsCountGreaterThanFour,
                                            arguments: count.formattedWithSeparator)
        default:
            return SBLocalization.localized(key: CartText.Cart.Footer.productsCountGreaterThanFour,
                                            arguments: count.formattedWithSeparator)
        }
    }
}
