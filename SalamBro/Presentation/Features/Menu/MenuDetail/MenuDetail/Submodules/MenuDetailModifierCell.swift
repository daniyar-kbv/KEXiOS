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

protocol MenuDetailModifierCellDelegate: AnyObject {
    func changeButtonTapped(at index: Int)
}

final class MenuDetailModifierCell: UITableViewCell {
    weak var delegate: MenuDetailModifierCellDelegate?

    private var viewModel: MenuDetailModifierCellViewModel

    private lazy var disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()

    private lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()

    private lazy var selectButton: UIButton = {
        let view = UIButton()
        view.setTitle(SBLocalization.localized(key: MenuText.MenuDetail.changeButton), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.setTitleColor(.kexRed, for: .normal)
        return view
    }()

    private var placeholderForValue = ""

    private var index: Int?

    init(viewModel: MenuDetailModifierCellViewModel, delegate: MenuDetailModifierCellDelegate, index: Int) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.index = index

        super.init(style: .default, reuseIdentifier: String(describing: Self.self))

        layoutUI()
        configureActions()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.outputs.name
            .bind(to: titleLabel.rx.attributedText)
            .disposed(by: disposeBag)

        viewModel.outputs.isRequired
            .subscribe(onNext: { [weak self] isRequired in
                if let isRequired = isRequired {
                    self?.placeholderForValue = isRequired ?
                        SBLocalization.localized(key: MenuText.MenuDetail.choose) :
                        SBLocalization.localized(key: MenuText.MenuDetail.chooseAdditional)
                }
            }).disposed(by: disposeBag)

        viewModel.outputs.value
            .subscribe(onNext: { [weak self] text in
                if let text = text {
                    self?.valueLabel.text = !text.isEmpty ? text : self?.placeholderForValue
                    self?.valueLabel.textColor = !text.isEmpty ? .darkGray : .mildBlue
                }
            }).disposed(by: disposeBag)
    }

    private func configureActions() {
        selectButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }

    private func layoutUI() {
        selectionStyle = .none

        [titleLabel, valueLabel, selectButton].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview()
        }

        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-8)
            $0.left.equalToSuperview()
        }

        selectButton.snp.makeConstraints {
            $0.left.equalTo(valueLabel.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.centerY.equalTo(valueLabel.snp.centerY)
            $0.width.equalTo(70)
        }
    }

    @objc private func changeButtonTapped() {
        if let index = index {
            delegate?.changeButtonTapped(at: index)
        }
    }
}
