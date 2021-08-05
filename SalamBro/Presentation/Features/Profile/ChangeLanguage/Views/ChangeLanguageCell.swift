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
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 10
        return view
    }()

    private var languageLabel = UILabel()

    private lazy var rightImage: UIImageView = {
        let view = UIImageView()
        view.image = SBImageResource.getIcon(for: ProfileIcons.ChangeLanguage.chackMark)
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

    func configure(with language: Language, isCurrent: Bool) {
        languageImageView.image = language.icon
        languageLabel.text = language.title
        rightImage.isHidden = !isCurrent
    }

    private func layoutUI() {
        tintColor = .kexRed
        selectionStyle = .none

        [languageImageView, rightImage, languageLabel].forEach {
            contentView.addSubview($0)
        }

        languageImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(32)
            $0.height.equalTo(24)
        }

        rightImage.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        languageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(languageImageView.snp.right).offset(12)
            $0.right.equalTo(rightImage.snp.left).offset(-12)
        }
    }
}

extension ChangeLanguageCell: Reusable {}
