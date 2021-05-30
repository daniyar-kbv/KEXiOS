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
        label.text = L10n.Authorization.title
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = L10n.Authorization.subtitle
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
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
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.greaterThanOrEqualTo(76)
        }

        addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(16)
        }
    }
}
