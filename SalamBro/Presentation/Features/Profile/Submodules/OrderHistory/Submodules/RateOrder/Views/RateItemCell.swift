//
//  RateItemCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Reusable
import SnapKit
import UIKit

final class RateItemCell: UICollectionViewCell {
    private lazy var cellView: UIView = {
        let view = UIView()
        view.borderColor = .kexRed
        view.borderWidth = 1
        view.isOpaque = true
        view.autoresizesSubviews = true
        view.clearsContextBeforeDrawing = true
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .kexRed
        label.textAlignment = .center
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: RateItem) {
        titleLabel.text = item.sample.name
        cellView.backgroundColor = item.isSelected ? .kexRed : .arcticWhite
        titleLabel.textColor = item.isSelected ? .arcticWhite : .kexRed
    }
}

extension RateItemCell {
    private func layoutUI() {
        contentView.addSubview(cellView)
        cellView.addSubview(titleLabel)

        cellView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}

extension RateItemCell: Reusable {}
