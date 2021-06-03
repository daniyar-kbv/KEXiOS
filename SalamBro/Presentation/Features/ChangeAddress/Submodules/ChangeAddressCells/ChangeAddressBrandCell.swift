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

    private let separatorView = UIView()

    private var chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "right")
        view.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layoutUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch accessoryType {
        case .none:
            accessoryView?.frame.origin.x += 15
            accessoryView?.frame.origin.y += 8
        default: break
        }
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
        case .none, .disclosureIndicator:
            accessoryView?.frame.origin.x += 15
            accessoryView = chevronImageView
        default: break
        }

        switch dto.isEnabled {
        case true: isUserInteractionEnabled = true
        case false: isUserInteractionEnabled = false
        }
    }

    private func layoutUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(14)
        }

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(20)
        }

        separatorView.backgroundColor = .calmGray
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-6)
            $0.height.equalTo(1)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(36)
        }
    }
}
