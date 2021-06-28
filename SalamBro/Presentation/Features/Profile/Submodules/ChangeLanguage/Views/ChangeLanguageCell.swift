//
//  ChangeLanguageCell.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/24/21.
//

import Reusable
import UIKit

final class ChangeLanguageCell: UITableViewCell {
    private lazy var languageImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private lazy var languageLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: Language) {
        languageImageView.image = item.type.icon
        languageLabel.text = item.type.title

        if item.checkmark {
            accessoryView = checkmark
        } else {
            accessoryView = .none
        }
    }

    private func layoutUI() {
        tintColor = .kexRed
        selectionStyle = .none

        [languageImageView, languageLabel].forEach {
            contentView.addSubview($0)
        }

        languageImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.equalToSuperview().offset(16)
        }

        languageLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.equalTo(languageImageView.snp.right).offset(4)
        }
    }
}

extension ChangeLanguageCell: Reusable {}
