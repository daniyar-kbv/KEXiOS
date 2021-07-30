//
//  AddedView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/25/21.
//

import SnapKit
import UIKit

final class AddedView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: MenuText.MenuDetail.added)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddedView {
    private func layoutUI() {
        backgroundColor = .arcticWhite
        cornerRadius = 6
        shadowColor = .darkGray
        shadowOpacity = 0.2
        shadowOffset = .zero
        shadowRadius = 5

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.left.right.equalToSuperview()
        }
    }
}
