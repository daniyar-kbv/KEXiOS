//
//  CartHeaderCell.swift
//  SalamBro
//
//  Created by Dan on 8/6/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class CartHeader: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel: CartHeaderViewModel

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        return view
    }()

    init(viewModel: CartHeaderViewModel) {
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
        viewModel.outputs.fontSize
            .subscribe(onNext: { [weak self] fontSize in
                self?.titleLabel.font = .systemFont(ofSize: fontSize, weight: .semibold)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        backgroundColor = .arcticWhite

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}
