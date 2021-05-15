//
//  SeparatorView.swift
//  SalamBro
//
//  Created by Arystan on 5/6/21.
//

import SnapKit
import UIKit

class SeparatorView: UIView {
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SeparatorView {
    func setupViews() {
        addSubview(separator)
    }

    func setupConstraints() {
        separator.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}
