//
//  CustomNavigationBarView.swift
//  SalamBro
//
//  Created by Arystan on 5/6/21.
//

import SnapKit
import UIKit

class CustomNavigationBarView: UIView {
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .kexRed
        button.setImage(UIImage(named: "chevron.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        return view
    }()

    lazy var barView = UIView()

    init(navigationTitle: String) {
        super.init(frame: .zero)
        setupViews(navigationTitle)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomNavigationBarView {
    func setupViews(_ text: String) {
        titleLabel.text = text
        backgroundColor = .arcticWhite
        barView.addSubview(titleLabel)
        barView.addSubview(backButton)
        addSubview(barView)
    }

    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        barView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
