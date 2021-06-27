//
//  CategoryCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

final class CategoryCell: UICollectionViewCell {
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .kexRed
        view.isHidden = true
        view.isOpaque = true
        view.autoresizesSubviews = true
        view.clearsContextBeforeDrawing = true
        view.layer.cornerRadius = 2
        return view
    }()

    public lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.AddressPickCell.deliverLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .mildBlue
        label.textAlignment = .center
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private var viewModel: CategoryCellViewModelProtocol! {
        didSet { bind() }
    }

    private var disposeBag = DisposeBag()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var isSelected: Bool {
        didSet {
            indicatorView.isHidden = isSelected ? false : true
            categoryLabel.textColor = isSelected ? .black : .mildBlue
        }
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func set(_ viewModel: CategoryCellViewModelProtocol?) {
        self.viewModel = viewModel
    }

    private func bind() {
        viewModel.categoryTitle
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension CategoryCell {
    private func layoutUI() {
        [indicatorView, categoryLabel].forEach {
            contentView.addSubview($0)
        }

        categoryLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview().inset(4)
        }

        indicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.height.equalTo(4)
            $0.width.equalTo(20)
        }
    }
}

extension CategoryCell: Reusable {}
