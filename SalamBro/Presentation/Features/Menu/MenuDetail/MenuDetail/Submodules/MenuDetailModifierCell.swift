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
    private var viewModel: MenuDetailModifierCellViewModel?
    private var index: Int?
    private var modifiersController: ModifiersController?
    private weak var viewController: UIViewController?

    private var placeholderForValue = ""

    private lazy var disposeBag = DisposeBag()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .regular)
        return view
    }()

    func set(viewModel: MenuDetailModifierCellViewModel,
             modifiersViewModel: ModifiersViewModel,
             viewController: UIViewController,
             index: Int)
    {
        self.viewModel = viewModel
        modifiersController = .init(viewModel: modifiersViewModel)
        self.viewController = viewController
        self.index = index

        layoutUI()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel?.outputs.name
            .bind(to: titleLabel.rx.attributedText)
            .disposed(by: disposeBag)

        viewModel?.outputs.isRequired
            .subscribe(onNext: { [weak self] isRequired in
                if let isRequired = isRequired {
                    self?.placeholderForValue = isRequired ?
                        SBLocalization.localized(key: MenuText.MenuDetail.choose) :
                        SBLocalization.localized(key: MenuText.MenuDetail.chooseAdditional)
                }
            }).disposed(by: disposeBag)
    }

    private func layoutUI() {
        guard let modifiersController = modifiersController else { return }

        selectionStyle = .none

        [titleLabel, modifiersController.view].compactMap { $0 }.forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalToSuperview()
        }

        modifiersController.view.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.bottom.equalToSuperview()
        }

        viewController?.addChild(modifiersController)
        modifiersController.didMove(toParent: viewController)
    }
}
