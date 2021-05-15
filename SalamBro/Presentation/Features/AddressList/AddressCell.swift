//
//  AddressCell.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import UIKit

public final class AddressCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        tintColor = .kexRed
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        textLabel?.textColor = .darkGray
    }

    private func setupConstraints() {}
}
