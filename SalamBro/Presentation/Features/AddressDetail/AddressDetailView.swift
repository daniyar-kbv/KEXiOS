//
//  AddressDetailView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/21/21.
//

import SnapKit
import UIKit

class AddressDetailView: UIView {
    private lazy var addressTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.text = L10n.AddressPicker.titleOne
        view.font = .systemFont(ofSize: 10, weight: .medium)
        return view
    }()

    private lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .darkGray
        return view
    }()

    private lazy var commentaryTitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.numberOfLines = 0
        view.text = "Комментарий"
        return view
    }()

    private lazy var commentaryLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 0
        view.textColor = .darkGray
        return view
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

extension AddressDetailView {
    public func configureAddress(name: String) {
        addressLabel.text = name
    }

    public func configureCommentary(commentary: String) {
        commentaryLabel.text = commentary
    }

    private func layoutUI() {
        [addressLabel, addressTitleLabel, commentaryLabel, commentaryTitleLabel].forEach {
            addSubview($0)
        }

        addressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(addressTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        commentaryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        commentaryLabel.snp.makeConstraints {
            $0.top.equalTo(commentaryTitleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }
    }
}
