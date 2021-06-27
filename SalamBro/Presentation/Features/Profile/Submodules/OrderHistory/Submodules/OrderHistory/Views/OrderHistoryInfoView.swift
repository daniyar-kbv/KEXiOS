//
//  OrderHistoryInfoStackView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import SnapKit
import UIKit

final class OrderHistoryInfoView: UIView {
    private var itemLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        return view
    }()

    private var infoLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        return view
    }()

    init(title: String, info: String) {
        super.init(frame: .zero)
        itemLabel.text = title
        infoLabel.text = info
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [itemLabel, infoLabel].forEach {
            addSubview($0)
        }
        itemLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(itemLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
