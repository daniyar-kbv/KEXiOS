//
//  ChangeAddressTableViewCell.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 20.05.2021.
//

import UIKit

protocol ChangeAddressCellPresentable: AnyObject {
    func configure(dto: ChangeAddressDTO)
}

final class ChangeAddressTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "ChangeAddressTableViewCell"
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch accessoryType {
        case .none: accessoryView?.frame.origin.x += 8
        case .detailDisclosureButton: accessoryView?.frame.origin.x -= 12
        default: break
        }
    }
}

// MARK: LayoutUI

extension ChangeAddressTableViewCell: ChangeAddressCellPresentable {
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
            $0.top.equalToSuperview().offset(2)
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
    }
}

struct ChangeAddressDTO {
    var isSelected: Bool = false
    var description: String?
    let accessoryType: UITableViewCell.AccessoryType
    let inputType: InputType

    enum InputType {
        case country
        case city
        case address
        case brand
        case empty

        var title: String {
            switch self {
            case .address: return "Адрес"
            case .brand: return "Бренд"
            case .city: return "Город"
            case .country: return "Страна"
            case .empty: return ""
            }
        }

        var placeholder: String {
            switch self {
            case .address: return "Введите адрес"
            case .brand: return "Выберите бренд"
            case .country: return "Выберите страну"
            case .city: return "Выберите город"
            case .empty: return ""
            }
        }
    }
}
