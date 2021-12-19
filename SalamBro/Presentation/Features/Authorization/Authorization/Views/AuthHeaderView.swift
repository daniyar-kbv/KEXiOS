//
//  AuthHeaderView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 29.05.2021.
//

import UIKit

final class AuthHeaderView: UIView {
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: AuthorizationText.Auth.title)
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: AuthorizationText.Auth.subtitle)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthHeaderView {
    private func layoutUI() {
        backgroundColor = .white
        addSubview(mainTitle)
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(76)
        }

        addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
