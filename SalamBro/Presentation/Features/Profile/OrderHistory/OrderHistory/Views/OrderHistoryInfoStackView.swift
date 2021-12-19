//
//  OrderHistoryInfoStackView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import SnapKit
import UIKit

final class OrderHistoryInfoStackView: UIStackView {
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
        view.font = .systemFont(ofSize: 14)
        view.textColor = .darkGray
        view.numberOfLines = 0
        return view
    }()

    init(title: String) {
        super.init(frame: .zero)
        itemLabel.text = title
        configureUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        axis = .vertical
        alignment = .fill
        spacing = 4

        addArrangedSubview(itemLabel)
        addArrangedSubview(infoLabel)
    }

    func configure(with info: String) {
        infoLabel.text = info
    }
}
