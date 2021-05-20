//
//  ChangeAddressEmptyCell.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 21.05.2021.
//

import UIKit

final class ChangeAddressEmptyCell: UITableViewCell {
    static let reuseIdentifier: String = "ChangeAddressEmptyCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChangeAddressEmptyCell: ChangeAddressCellPresentable {
    func configure(dto _: ChangeAddressDTO) {}
}
