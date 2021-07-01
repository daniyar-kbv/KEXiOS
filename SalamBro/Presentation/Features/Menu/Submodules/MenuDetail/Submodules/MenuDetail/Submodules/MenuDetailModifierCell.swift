//
//  MenuDetailModifierCell.swift
//  SalamBro
//
//  Created by Dan on 6/29/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class MenuDetailModifierCell: UITableViewCell {
    private var viewModel: MenuDetailModifierCellViewModel

    private lazy var disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()

    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.textColor = .darkGray
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    private lazy var selectButton: UIButton = {
        let view = UIButton()
        view.setTitle(L10n.MenuDetail.chooseAdditionalItemButton, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.setTitleColor(.kexRed, for: .normal)
        return view
    }()

    private lazy var bottomStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [valueLabel, selectButton])
        view.distribution = .equalSpacing
        view.alignment = .bottom
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()

    init(viewModel: MenuDetailModifierCellViewModel) {
        self.viewModel = viewModel

        super.init(style: .default, reuseIdentifier: String(describing: Self.self))

        layoutUI()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(value: Modifier) {
        viewModel.set(value: value)
    }

    func getValue() -> Modifier? {
        return viewModel.getValue()
    }

    private func bindViewModel() {
        viewModel.outputs.name
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.outputs.value
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        selectionStyle = .none

        [titleLabel, bottomStack].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview()
        }

        bottomStack.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-8)
            $0.left.right.equalToSuperview()
        }
    }
}
