//
//  ChangeAddressBrandCell.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 20.05.2021.
//

import UIKit

// MARK: Tech debt, sorry for boiler plate

final class ChangeAddressBrandCell: UITableViewCell {
    static let reuseIdentifier: String = "ChangeAddressBrandCell"
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .mildBlue
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lbl.backgroundColor = .white
        return lbl
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .mildBlue
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.backgroundColor = .white
        return lbl
    }()

    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .mildBlue
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        lbl.backgroundColor = .white
        lbl.text = "Наличие или отсутствие того или иного бренда - зависит от Вашего адреса доставки"
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()

    private let separatorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: LayoutUI

extension ChangeAddressBrandCell: ChangeAddressCellPresentable {
    func configure(dto: ChangeAddressDTO) {
        titleLabel.text = dto.inputType.title

        if let descriptionText = dto.description {
            descriptionLabel.text = descriptionText
            descriptionLabel.textColor = .darkGray
        } else {
            descriptionLabel.text = dto.inputType.placeholder
            descriptionLabel.textColor = .mildBlue
        }

        switch dto.accessoryType {
        case .none: accessoryView = UIImageView(image: Asset.chevronBottom.image)
        default: accessoryType = dto.accessoryType
        }
    }

    private func layoutUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(14)
        }

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }

        separatorView.backgroundColor = .calmGray
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(16)
        }

        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(24)
        }
    }
}
