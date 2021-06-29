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
    var viewModel: MenuDetailModifierCellViewModel!

    lazy var disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = L10n.MenuDetail.additionalItemLabel
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 12)
        return view
    }()

    private lazy var valueLabel: UILabel = {
        let view = UILabel()
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(modifierGroup: ModifierGroup) {
        viewModel = MenuDetailModifierCellViewModelImpl(modifierGroup: modifierGroup)

        bindViewModel()
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
        [titleLabel, selectButton, valueLabel].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        selectButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.left.bottom.equalToSuperview()
            $0.right.equalTo(selectButton.snp.left).offset(-8)
        }
    }
}
