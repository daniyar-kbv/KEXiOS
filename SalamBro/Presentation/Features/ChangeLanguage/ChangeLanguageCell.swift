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

    func configure(title: String, image: UIImage) {
        languageImageView.image = image
        languageLabel.text = title
    }

    private func layoutUI() {
        tintColor = .kexRed
        selectionStyle = .none

        [languageImageView, languageLabel].forEach {
            contentView.addSubview($0)
        }

        languageImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        languageLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(languageImageView.snp.right).offset(4)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }

    func didSelect(indexPath _: IndexPath) {
        accessoryView = checkmark
    }

    func didDeselect(indexPath _: IndexPath) {
        accessoryView = .none
    }
}

extension ChangeLanguageCell: Reusable {}
