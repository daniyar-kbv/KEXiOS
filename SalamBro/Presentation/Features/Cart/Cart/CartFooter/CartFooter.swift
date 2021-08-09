//
//  CartFooter.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import RxCocoa
import RxSwift
import UIKit

final class CartFooter: UIView {
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

        super.init(frame: .zero)

        bindViewModel()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.outputs.countText
            .bind(to: countLabel.rx.text)
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
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
        }
    }
}
